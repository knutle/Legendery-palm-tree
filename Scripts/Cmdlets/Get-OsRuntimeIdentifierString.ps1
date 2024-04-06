
function Get-OsRuntimeIdentifierString {
    return "$([System.Runtime.InteropServices.RuntimeInformation]::RuntimeIdentifier) $([System.Environment]::OSVersion.Version.ToString()) ($([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture))"
}
