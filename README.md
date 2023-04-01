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
PGPDecrypt-Message -pgp_encrypted_message @"
-----BEGIN PGP MESSAGE-----
Version: BCPG C# v1.8.10.0

owJ4nAHkARv+hQGMAzQrCxerEdDLAQwA5KLnXJT/MPZ1OjqeQTouGjSgu2jPDENS
8NAJDGA7UyddjI672VbE2PyRqWyFT9Np3mnMxfLu/32mtrSZA7YF2sZ3bc8hFgha
UAnDr0+BhGzGign9Kp/iDnoh8RIc72ooStLXwLlKiAzDqMQ8npU2B4RyhwUM0MFC
c0+NjZBEHFRG7JavJ9FPdF3W9G0KMOPQVTPZghiP/zgM/2Ji8nH5vSSldIebhvj4
M85RHUwWKDnDqjymiklrR1Necc3H6bOW6if3UeRIQrSRuyBeEZCE7EHlSZ6ysC9d
fWHUQXn2Fcd1R2TfvXnzc4//lXFrozRtiwNrSvqGR7oeB1Q42SZoaTrKi8MexgFV
BJYAjTL9Dgbxazx6gMmBDS8fjSp4fHvc21L7Tra/JmWxND3f02S0JsG5AfuCf3BS
QJ/h0mukvuclM2piLAQM/2XxDsgWG9EbzLwndJEPNzi8PpwtDcAySaiUAUtLYGE4
Ja+fjftZMiWB5sG843EhcAeHiYaswPyH0lMBIyhdFtA34MkaY3uqfZZIbqN24iwL
bFYLVMxLZ1ehVr/K6tmRMipIc1nOsZBwC5+rmg5rXDUthq1/PKWVhYTxY4MXaFl3
DLvyNnvcb1Loeq78VqRs5lE=
=hoSa
-----END PGP MESSAGE-----

"@ -pgp_private_key @"
-----BEGIN PGP PRIVATE KEY BLOCK-----

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
WDSeC3yWedFxCg==
=3B7M
-----END PGP PRIVATE KEY BLOCK-----
"@ -private_key_passphrase 'Y3J5cHRfazMzcDNy'
```
**Output**
```
I'm encrypting this message!
```
