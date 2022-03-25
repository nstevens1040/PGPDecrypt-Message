# PGPDecrypt-Message
This script for Windows PowerShell will decrypt a PGP encrypted (and armored) string using your PGP private key and passphrase.  
  
This script uses **[BouncyCastle.NetFramework](https://www.nuget.org/packages/BouncyCastle.NetFramework/)** *(also [bc-chsarp](https://github.com/bcgit/bc-csharp))*.  
  
## Installation
The PowerShell snippet below will make the script available in the current PowerShell session.  
  
The first time you run **PGPDecrypt-Message** it will install BouncyCastle.NetFramework.  
```ps1
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
iex (irm https://raw.githubusercontent.com/nstevens1040/PGPDecrypt-Message/main/PGPDecrypt-Message.ps1)
```  
## Usage
```

NAME
    PGPDecrypt-Message
    
SYNTAX
    PGPDecrypt-Message [-pgp_encrypted_message] <string> [-pgp_private_key] <string> [[-private_key_passphrase] <string>]  [<CommonParameters>]
    
    
PARAMETERS
    -pgp_encrypted_message <string>
        
        Required?                    true
        Position?                    0
        Accept pipeline input?       false
        Parameter set name           (All)
        Aliases                      None
        Dynamic?                     false
        
    -pgp_private_key <string>
        
        Required?                    true
        Position?                    1
        Accept pipeline input?       false
        Parameter set name           (All)
        Aliases                      None
        Dynamic?                     false
        
    -private_key_passphrase <string>
        
        Required?                    false
        Position?                    2
        Accept pipeline input?       false
        Parameter set name           (All)
        Aliases                      None
        Dynamic?                     false
        
    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see 
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216). 
    
    
INPUTS
    None
    
    
OUTPUTS
    System.Object
    
ALIASES
    None
    

REMARKS
    None
```

## Example
*(private key is a throwaway)*
```ps1
$dec = PGPDecrypt-Message -pgp_encrypted_message @"
-----BEGIN PGP MESSAGE-----
Version: BCPG C# v1.8.5.0

owJ4nAHkARv+hQGMAww0WGoHf/5zAQv/cL3yJ+2/g5pPF5qi7FvrbYcxvPROGbIy
nkl4zssfrWTa/xuVmAi/94d/WkhfLrDouvYEa3Xzkbldvr3AtIN2DHQpi7khjt/0
Yyu1Q95KFlDTfXuENi2RSpLcc6fgqXxgN3y5aERwAH8J358bYksG7S9eq1SLv38+
ySkONaxWZpdf2v47FrW4It/HVGPCSfWx8CNDkqWjfMI1pA/BS7qJlDmdCYUiwe4F
537muuvj6I6hAySlT6N0VFno6+VsFfMImiqKRwMH8MiuXcBYqSOaa+Mb2hiZSwJ+
i/9xZ7K/O6QxAkZX3yUOcrsMalDBeSKXlJALVqXC7zrJoaeAtQ9SBP/AVxY3Iu/G
V92Trr4iS4jnDrcZA0c1BhH7v61IUscrIL94jsI04M1IoNUfhin2nE9rh+5hRxJB
DDNhRWiPTpUU7qGPl98jXljU315nb7KkCVXNM+8hkbPkt4kNZOAJ0iuwTGooyvJk
m1xMtS18Oh4R08vDKRV1wz49pkELjD+p0lMBlpXX51k43lxlZb9DVVrjTldB5Gxq
IsS5VYlchLkuK/OnWCr2p0HmVZhBGImrIf7lRwHcIIX+DkJdYE59XFDZNAm382gr
ScbsIvUrAaMfyCvioEJe6NM=
=/Ohf
-----END PGP MESSAGE-----

"@ -pgp_private_key @"
-----BEGIN PGP PRIVATE KEY BLOCK-----

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
RW9WZi6oL2uEExmCt1EH5XyJPbI=
=1087
-----END PGP PRIVATE KEY BLOCK-----
"@
```
**Output**
```ps1
I'm encrypting this message!
```
