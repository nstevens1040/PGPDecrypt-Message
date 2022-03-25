function PGPDecrypt-Message
{
    [cmdletbinding()]
    Param(
        [Parameter(Mandatory=$true)]
        [string]$pgp_encrypted_message,
        [Parameter(Mandatory=$true)]
        [string]$pgp_private_key,
        [string]$private_key_passphrase
    )
   if(!(get-package -Name BouncyCastle.NetFramework -ea 0))
    {
        Add-Type -TypeDefinition "namespace Bouncy`n{`n    using System;`n    using System.Diagnostics;`n    using System.Threading;`n    using System.Threading.Tasks;`n    using System.Linq;`n    using System.Collections.Generic;`n    public class Castle`n    {`n        public static void Install()`n        {`n            using(Process p = new Process()`n            {`n                StartInfo = new ProcessStartInfo()`n                {`n                    FileName = @`"C:\Windows\System32\WindowsPowerShell\v1.0\PowerShell.exe`",`n                    Arguments = `"-noprofile -ep remotesigned -c \`"[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12; `$i = 0;`$name = 'nuget'; `$packageSources = Get-PackageSource | ? {`$_.Name -eq `$name };while(`$packageSources.count -gt 0){`$name = 'nuget' + `$i;`$packageSources = Get-PackageSource | ? {`$_.Name -eq `$name};`$i++};Register-PackageSource -Name `$name -Location 'https://www.nuget.org/api/v2' -ProviderName NuGet -Trusted; Install-Package -Name BouncyCastle.NetFramework -Source `$name; Unregister-PackageSource -Name `$name\`"`",`n                    Verb = `"RunAs`"`n                }`n            })`n            {`n                p.Start();`n                p.WaitForExit();`n            }`n        }`n    }`n}`n"
        [Bouncy.Castle]::Install()
        while(!(get-package -Name BouncyCastle.NetFramework -ea 0)){}
    }
    $dll = [IO.FileInfo]::New((get-package -Name BouncyCastle.NetFramework | % source)).Directory.EnumerateFiles("*.dll",[System.IO.SearchOption]::AllDirectories)[0].FullName
    Add-Type -Path $dll
    if([string]::IsNullOrEmpty($private_key_passphrase))
    {
        $private_key_passphrase_secure = Read-Host -AsSecureString -Prompt "Please enter your passphrase: "
    }
    $enc_stream = [System.IO.MemoryStream]::New([System.Text.Encoding]::ASCII.GetBytes($pgp_encrypted_message))
    $stream = [Org.BouncyCastle.Bcpg.OpenPgp.PgpUtilities]::GetDecoderStream($enc_stream)
    $stream_list = [system.Collections.Generic.List[System.IO.Stream]]::New()
    $stream_list.Add($stream)
    $factory = [Org.BouncyCastle.Bcpg.OpenPgp.PgpObjectFactory]::new($stream)
    $data_object = $factory.NextPgpObject()
    $priv_stream = [System.IO.MemoryStream]::New([System.Text.Encoding]::ASCII.GetBytes($pgp_private_key))
    $sec_rings = @([Org.BouncyCastle.Bcpg.OpenPgp.PgpSecretKeyRingBundle]::new(
        [Org.BouncyCastle.Bcpg.OpenPgp.PgpUtilities]::GetDecoderStream($priv_stream)
    ).GetKeyRings()).Where({$_.GetType() -eq [Org.BouncyCastle.Bcpg.OpenPgp.PgpSecretKeyRing]})
    if($sec_rings -as [Org.BouncyCastle.Bcpg.OpenPgp.PgpSecretKeyRing[]])
    {
        $secret_keyrings = $sec_rings
    } else {
        $secret_keyrings = $sec_rings.ToArray()
    }
    $secret_keys = [System.Collections.Generic.Dictionary[[long],[Org.BouncyCastle.Bcpg.OpenPgp.PgpSecretKey]]]::New()
    @($secret_keyrings[0].GetSecretKeys()).Where({$_.GetType() -eq [Org.BouncyCastle.Bcpg.OpenPgp.PgpSecretKey] }).ForEach({ $secret_keys.Add($_.KeyId,$_) })
    while(($data_object.GetType() -ne [Org.BouncyCastle.Bcpg.OpenPgp.PgpLiteralData]))
    {
        try {
            $com_data = $data_object -as [Org.BouncyCastle.Bcpg.OpenPgp.PgpCompressedData]
            $list_data = $data_object -as [Org.BouncyCastle.Bcpg.OpenPgp.PgpEncryptedDataList]
            if($com_data)
            {
                $stream = $com_data.GetDataStream()
                $stream_list.Add($stream)
                $factory = [Org.BouncyCastle.Bcpg.OpenPgp.PgpObjectFactory]::new($stream)
            }
            if($list_data)
            {
                $enc_data_list = @($list_data.GetEncryptedDataObjects()).Where({$_.GetType() -eq [Org.BouncyCastle.Bcpg.OpenPgp.PgpPublicKeyEncryptedData]})[0]
                if($private_key_passphrase_secure)
                {
                    $decrypt_key = $secret_keys[$enc_data_list.KeyId].ExtractPrivateKey([System.Net.NetworkCredential]::new("",$private_key_passphrase).Password.ToCharArray())
                } else {
                    $decrypt_key = $secret_keys[$enc_data_list.KeyId].ExtractPrivateKey($private_key_passphrase.ToCharArray())
                }
                $decrypt_key = $secret_keys[$enc_data_list.KeyId].ExtractPrivateKey($private_key_passphrase.ToCharArray())
                $stream = $enc_data_list.GetDataStream($decrypt_key)
                $stream_list.Add($stream)
                $factory = [Org.BouncyCastle.Bcpg.OpenPgp.PgpObjectFactory]::new($stream)
            }
            $data_object = $factory.NextPgpObject()
        }
        catch {
            $_ | select *
        }
    }
    foreach ($stream_item in $stream_list)
    {
        $stream_item.Close();
        $stream_item.Dispose();
    }
    $literal_data = [Org.BouncyCastle.Bcpg.OpenPgp.PgpLiteralData]$data_object
    $mem = [System.IO.MemoryStream]::New()
    $clear_data = $literal_data.GetInputStream()
    $null = [Org.BouncyCastle.Utilities.IO.Streams]::PipeAll($clear_data,$mem)
    $mem.Position = 0
    $t = $mem.ToArray()
    $string = [System.Text.Encoding]::UTF8.GetString($t)
    return $string
}
