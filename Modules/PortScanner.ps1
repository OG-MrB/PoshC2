﻿<#
.Synopsis
    Quick PortScan / EgressBuster

    PortScan / EgressBuster 2017
    Rob Maslen @rbmaslen 

.DESCRIPTION
	PS C:\> Usage: PortScan -IPaddress <IPaddress> -Ports <Ports> -maxQueriesPS <maxQueriesPS> -Delay <Delay>
.EXAMPLE
    PS C:\> PortScan -IPaddress 127.0.0.1 -Ports 1-65535 -maxQueriesPS 10000
.EXAMPLE
    PS C:\> PortScan -IPaddress 192.168.1.0/24 -Ports 1-65535 -maxQueriesPS 10000
.EXAMPLE
    PS C:\> PortScan -IPaddress 192.168.1.1-50 -Ports "80,443,55" -maxQueriesPS 10000
.EXAMPLE
    PS C:\> PortScan -IPaddress 192.168.1.1-50 -Ports "80,443,55" -maxQueriesPS 1 -Delay 1
#>
$psloaded = $null
function PortScan {
param(
[Parameter(Mandatory=$true)][string]$IPaddress, 
[Parameter(Mandatory=$false)][string]$Ports="1-1000",
[Parameter(Mandatory=$false)][string]$maxQueriesPS=1000,
[Parameter(Mandatory=$false)][int]$Delay=0
)

    if ($psversiontable.CLRVersion.Major -lt 3) {

        echo "Not running on CLRVersion 4 or above. Try 'migrate' to use unmanaged powershell"

    } else {

        $Delay = $Delay *1000
        if ($psloaded -ne "TRUE") {
            $script:psloaded = "TRUE"
            echo "Loading Assembly"
            $ps = "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dD5rX19CYWNraW5nRmllbGQAPFNvY2tldD5rX19CYWNraW5nRmllbGQAPFNjYW5FbmRFdmVudD5rX19CYWNraW5nRmllbGQAPFNjYW5EZWxheUV2ZW50PmtfX0JhY2tpbmdGaWVsZAA8RW5kUG9ydD5rX19CYWNraW5nRmllbGQAPEN1cnJlbnRQb3J0PmtfX0JhY2tpbmdGaWVsZAA8U3RhcnRQb3J0PmtfX0JhY2tpbmdGaWVsZAA8X1BvcnRTeW50YXg+a19fQmFja2luZ0ZpZWxkADxEZWxheT5rX19CYWNraW5nRmllbGQAQXBwZW5kAGdldF9NZXNzYWdlAElzSVBSYW5nZQBQcm9jZXNzSVBSYW5nZQBJcFJhbmdlAFByb2Nlc3NDaWRyUmFuZ2UAZ2V0X1RhcmdldFJhbmdlAHNldF9UYXJnZXRSYW5nZQBJRW51bWVyYWJsZQBJRGlzcG9zYWJsZQBzZXRfQ3Vyc29yVmlzaWJsZQBFdmVudFdhaXRIYW5kbGUAQ29uc29sZQBwb3NpdGlvbk5hbWUAQ2hlY2tIb3N0TmFtZQBuYW1lAERhdGVUaW1lAFdhaXRPbmUAQXBwZW5kTGluZQBXcml0ZUxpbmUAVXJpSG9zdE5hbWVUeXBlAFByb3RvY29sVHlwZQBTb2NrZXRUeXBlAFNlbWFwaG9yZQBDYXB0dXJlAFJlbGVhc2UAQ2xvc2UARGlzcG9zZQBUcnlQYXJzZQBSZXZlcnNlAGdldF9Bc3luY1N0YXRlAFRDUFNjYW5TdGF0ZQBnZXRfU2NhblN0YXRlAHNldF9TY2FuU3RhdGUAc2NhblN0YXRlAHNjYW5uZXJTdGF0ZQBXcml0ZQBDb21waWxlckdlbmVyYXRlZEF0dHJpYnV0ZQBHdWlkQXR0cmlidXRlAERlYnVnZ2FibGVBdHRyaWJ1dGUAQ29tVmlzaWJsZUF0dHJpYnV0ZQBBc3NlbWJseVRpdGxlQXR0cmlidXRlAEFzc2VtYmx5VHJhZGVtYXJrQXR0cmlidXRlAEFzc2VtYmx5RmlsZVZlcnNpb25BdHRyaWJ1dGUAQXNzZW1ibHlDb25maWd1cmF0aW9uQXR0cmlidXRlAEFzc2VtYmx5RGVzY3JpcHRpb25BdHRyaWJ1dGUARGVmYXVsdE1lbWJlckF0dHJpYnV0ZQBDb21waWxhdGlvblJlbGF4YXRpb25zQXR0cmlidXRlAEFzc2VtYmx5UHJvZHVjdEF0dHJpYnV0ZQBBc3NlbWJseUNvcHlyaWdodEF0dHJpYnV0ZQBBc3NlbWJseUNvbXBhbnlBdHRyaWJ1dGUAUnVudGltZUNvbXBhdGliaWxpdHlBdHRyaWJ1dGUAZ2V0X1ZhbHVlAGdldF9IYXNWYWx1ZQB2YWx1ZQBTeXN0ZW0uVGhyZWFkaW5nAGdldF9Qb3J0c1JlbWFpbmluZwBnZXRfVG90YWxTY2FubmluZwBzZXRfVG90YWxTY2FubmluZwBDdXJyZW50U2Nhbm5pbmcAVG9TdHJpbmcAVUludFRvSXBTdHJpbmcARGVjcmVtZW50V2FpdGluZwBJbmNyZW1lbnRXYWl0aW5nAHJhbmdlTWNoAGNpZHJtY2gASXBSYW5nZU1hdGNoAElwQ2lkck1hdGNoAGdldF9MZW5ndGgAc2V0X0xlbmd0aABtYXBOYW1lVG9QcmV2V3JpdGVMZW5ndGgAVXJpAEFzeW5jQ2FsbGJhY2sAV2FpdENhbGxiYWNrAEhvc3RUb05ldHdvcmsAdmVydGljYWwAX2ludGVybmFsAFBvcnRTY2FubmVyLURsbABQb3J0U2Nhbm5lci1EbGwuZGxsAFRocmVhZFBvb2wAV3JpdGVMaW5lSW1wbABXcml0ZUltcGwAV3JpdGVBdFJlY1Bvc2l0aW9uSW1wbABSZWNvcmRQb3NpdGlvbkltcGwAUHJvY2Vzc1RhcmdldHNJbXBsAGdldF9JdGVtAHNldF9JdGVtAFF1ZXVlVXNlcldvcmtJdGVtAFN5c3RlbQBUcmltAERvU2NhbgBnZXRfUG9ydHNUb1NjYW4Ac2V0X1BvcnRzVG9TY2FuAFBlcmZvcm1UQ1BDb25uZWN0U2NhbgBTdGFydFNjYW4AU3lzdGVtLlJlZmxlY3Rpb24AR3JvdXBDb2xsZWN0aW9uAEtleUNvbGxlY3Rpb24AV3JpdGVBdFJlY1Bvc2l0aW9uAFJlY29yZFBvc2l0aW9uAG1hcE5hbWVUb0N1cnNvclBvc2l0aW9uAEludmFsaWRPcGVyYXRpb25FeGNlcHRpb24AUG9ydFNjYW5uZXJfRGxsLkNvbW1vbgBQb3J0U2Nhbm5lci5Db21tb24AaXAAZ2V0X0N1cnNvclRvcABzZXRfQ3Vyc29yVG9wAEdyb3VwAENoYXIAX2hpQWRkcgBfbG9BZGRyAElzSVBDaWRyAF9pcF9jaWRyAF9pcGNpZHIAU3RyaW5nQnVpbGRlcgBfbG9ja2VyAFBvcnRTY2FubmVyLkNvbnNvbGVDb250cm9sbGVyAFBvcnRTY2FubmVyX0RsbC5TY2FubmVyAFRDUENvbm5lY3RTY2FubmVyAENvbnNvbGVVcGRhdGVyAEVudGVyAEJpdENvbnZlcnRlcgBJRW51bWVyYXRvcgBnZXRfSVBFbnVtZXJhdG9yAElQUmFuZ2VFbnVtZXJhdG9yAFN5c3RlbS5Db2xsZWN0aW9ucy5JRW51bWVyYWJsZS5HZXRFbnVtZXJhdG9yAC5jdG9yAC5jY3RvcgBNb25pdG9yAFN5c3RlbS5EaWFnbm9zdGljcwBTZXRNYXhUaHJlYWRzAFN5c3RlbS5SdW50aW1lLkludGVyb3BTZXJ2aWNlcwBTeXN0ZW0uUnVudGltZS5Db21waWxlclNlcnZpY2VzAERlYnVnZ2luZ01vZGVzAEdldEFkZHJlc3NCeXRlcwBHZXRCeXRlcwBJUHY0VG9vbHMARG5zAENvbnRhaW5zAFN5c3RlbS5UZXh0LlJlZ3VsYXJFeHByZXNzaW9ucwBTeXN0ZW0uQ29sbGVjdGlvbnMAcmV0aHJvd0V4Y2VwdGlvbnMAZ2V0X0dyb3VwcwBQb3J0U2Nhbm5lcl9EbGwuSGVscGVycwBnZXRfU3VjY2VzcwBJUEFkZHJlc3MAYWRkcmVzcwBnZXRfVGFyZ2V0cwBzZXRfVGFyZ2V0cwBnZXRfVENQU2NhblRhcmdldHMAUHJvY2Vzc1RhcmdldHMAU3lzdGVtLk5ldC5Tb2NrZXRzAGdldF9SZXN1bHRzAFdyaXRlVG9SZXN1bHRzAFNldFN0YXJ0QW5kRW5kUG9ydHMAZ2V0X09wZW5Qb3J0cwBzZXRfT3BlblBvcnRzAHBvcnRzAHRhcmdldEhvc3RzAGdldF9LZXlzAElzSVBSYW5nZUZvcm1hdABPYmplY3QARW5kQ29ubmVjdABCZWdpbkNvbm5lY3QAU3lzdGVtLk5ldABTZXQAZ2V0X1RhcmdldABzZXRfVGFyZ2V0AFRDUFNjYW5TdGF0ZVRhcmdldAB0YXJnZXQAZ2V0X1NvY2tldABzZXRfU29ja2V0AFRDUFNjYW5TdGF0ZVNvY2tldABSZXNldABnZXRfQ3Vyc29yTGVmdABzZXRfQ3Vyc29yTGVmdABTcGxpdABJbml0AEV4aXQAR2V0VmFsdWVPckRlZmF1bHQASUFzeW5jUmVzdWx0AERlY3JlbWVudABJbmNyZW1lbnQAU3lzdGVtLkNvbGxlY3Rpb25zLklFbnVtZXJhdG9yLkN1cnJlbnQAU3lzdGVtLkNvbGxlY3Rpb25zLklFbnVtZXJhdG9yLmdldF9DdXJyZW50AF9jdXJyZW50AE1heENvbmN1cnJlbnQAbWF4Q29uY3VycmVudABnZXRfU2NhbkVuZEV2ZW50AHNldF9TY2FuRW5kRXZlbnQAQXV0b1Jlc2V0RXZlbnQAZ2V0X1NjYW5EZWxheUV2ZW50AHNldF9TY2FuRGVsYXlFdmVudABJUEVuZFBvaW50AGdldF9Db3VudABTY2FuSVBQb3J0AGdldF9FbmRQb3J0AHNldF9FbmRQb3J0AGdldF9DdXJyZW50UG9ydABzZXRfQ3VycmVudFBvcnQAZ2V0X1N0YXJ0UG9ydABzZXRfU3RhcnRQb3J0AFNvcnQAZ2V0X0FkZHJlc3NMaXN0AHRhcmdldEhvc3QAaG9zdABNb3ZlTmV4dABTeXN0ZW0uVGV4dAB0ZXh0AGdldF9Ob3cAZ2V0X19Qb3J0U3ludGF4AHNldF9fUG9ydFN5bnRheABfaXBSYW5nZVJlZ2V4AF9pcFJlZ2V4AF9pcENpZHJSZWdleABnZXRfRGVsYXkAc2V0X0RlbGF5AFRyaWdnZXJEZWxheQBkZWxheQBBcnJheQBDb250YWluc0tleQBBZGRyZXNzRmFtaWx5AElQSG9zdEVudHJ5AEdldEhvc3RFbnRyeQBJc051bGxPckVtcHR5AAArWwBYAF0AIABFAHIAcgBvAHIAIABvAGMAYwB1AHIAZQBkACAAewAwAH0AAFlbAC0AXQAgAFMAYwBhAG4AbgBpAG4AZwA6ACAAewAwAH0AIABQAG8AcgB0AHMAOgAgAHsAMQB9ACAAdwBpAHQAaAAgAGQAZQBsAGEAeQAgAHsAMgB9AHMAAStbAC0AXQAgAEMAdQByAHIAZQBuAHQAIABJAFAALwBQAG8AcgB0ADoAIAABF0MAdQByAHIAZQBuAHQAUABvAHIAdAAAAQArWwAtAF0AIABQAG8AcgB0AHMAIABSAGUAbQBhAGkAbgBpAG4AZwA6ACAAARNSAGUAbQBhAGkAbgBpAG4AZwAAB3sAMAB9AAAnWwAtAF0AIABTAHQAYQByAHQAIAB0AGkAbQBlADoAIAB7ADAAfQABI1sAKwBdACAARQBuAGQAIAB0AGkAbQBlADoAIAB7ADAAfQAAG1sAKwBdACAAUgBlAHMAdQBsAHQAcwA6ACAAAA9SAGUAcwB1AGwAdABzAAAJWwBJAFAAXQAAF1AATwBSAFQACQBTAFQAQQBUAFUAUwAAC1sAewAwAH0AXQAAGXsAMAB9AC8AdABjAHAACQBPAFAARQBOAAAtWwArAF0AIABSAGUAcwB1AGwAdABzADoAIABOAG8AbgBlACAAbwBwAGUAbgAAR1sAWABdACAAUwB0AGEAcgB0AFMAYwBhAG4AOgAgAFQAQwBQAFMAYwBhAG4AUwB0AGEAdABlACAAaQBzACAAbgB1AGwAbAAAD3sAMAB9ADoAewAxAH0AAEtbAFgAXQAgAEUAbgBkAEMAbwBuAG4AZQBjAHQAOgAgAHMAYwBhAG4AUwB0AGEAdABlAFMAbwBjAGsAIABpAHMAIABuAHUAbABsAAArWwArAF0AIABQAG8AcgB0ACAATwBwAGUAbgAgAHsAMAB9ADoAewAxAH0AAIEhXgAoAD8APABpAHAAPgAoACgAWwAwAC0AOQBdAHwAWwAxAC0AOQBdAFsAMAAtADkAXQB8ADEAWwAwAC0AOQBdAHsAMgB9AHwAMgBbADAALQA0AF0AWwAwAC0AOQBdAHwAMgA1AFsAMAAtADUAXQApAFwALgApAHsAMwB9ACgAWwAwAC0AOQBdAHwAWwAxAC0AOQBdAFsAMAAtADkAXQB8ADEAWwAwAC0AOQBdAHsAMgB9AHwAMgBbADAALQA0AF0AWwAwAC0AOQBdAHwAMgA1AFsAMAAtADUAXQApACkAKABcAC8AKAA/ADwAYwBpAGQAcgA+ACgAXABkAHwAWwAxAC0AMgBdAFwAZAB8ADMAWwAwAC0AMgBdACkAKQApACQAAYDTXgAoACgAWwAwAC0AOQBdAHwAWwAxAC0AOQBdAFsAMAAtADkAXQB8ADEAWwAwAC0AOQBdAHsAMgB9AHwAMgBbADAALQA0AF0AWwAwAC0AOQBdAHwAMgA1AFsAMAAtADUAXQApAFwALgApAHsAMwB9ACgAWwAwAC0AOQBdAHwAWwAxAC0AOQBdAFsAMAAtADkAXQB8ADEAWwAwAC0AOQBdAHsAMgB9AHwAMgBbADAALQA0AF0AWwAwAC0AOQBdAHwAMgA1AFsAMAAtADUAXQApACQAAYFpXgAoAD8APABpAHAAPgAoACgAWwAwAC0AOQBdAHwAWwAxAC0AOQBdAFsAMAAtADkAXQB8ADEAWwAwAC0AOQBdAHsAMgB9AHwAMgBbADAALQA0AF0AWwAwAC0AOQBdAHwAMgA1AFsAMAAtADUAXQApAFwALgApAHsAMwB9ACgAPwA8AGYAcgBvAG0APgAoAFsAMAAtADkAXQB8AFsAMQAtADkAXQBbADAALQA5AF0AfAAxAFsAMAAtADkAXQB7ADIAfQB8ADIAWwAwAC0ANABdAFsAMAAtADkAXQB8ADIANQBbADAALQA1AF0AKQApACkAKABcAC0AKAA/ADwAdABvAD4AKABbADAALQA5AF0AfABbADEALQA5AF0AWwAwAC0AOQBdAHwAMQBbADAALQA5AF0AewAyAH0AfAAyAFsAMAAtADQAXQBbADAALQA5AF0AfAAyADUAWwAwAC0ANQBdACkAKQApACQAAUVbAFgAXQAgAFUAbgBhAGIAbABlACAAdABvACAAcgBlAHMAbwBsAHYAZQAgAHQAaABlACAAaABvAHMAdAAgAHsAMAB9AAAxWwBYAF0AIABJAFAAQQBkAGQAcgBlAHMAcwAgAGkAcwAgAGkAbgB2AGEAbABpAGQAAAMtAAFFUABvAHIAdAAgAHIAYQBuAGcAZQAgAHMAeQBuAHQAYQB4ACAAewAwAH0AIABpAHMAIABpAG4AYwBvAHIAcgBlAGMAdAAAK1AAbwByAHQAIAB7ADAAfQAgAGkAcwAgAG4AbwB0ACAAdgBhAGwAaQBkAABvSQBQACAAUgBhAG4AZwBlACAAbQB1AHMAdAAgAGUAaQB0AGgAZQByACAAYgBlACAAaQBuACAASQBQAC8AQwBJAEQAUgAgAG8AcgAgAEkAUAAgAHQAbwAtAGYAcgBvAG0AIABmAG8AcgBtAGEAdAABBWkAcAAACWYAcgBvAG0AAAV0AG8AAFVJAFAAIABSAGEAbgBnAGUAIAB0AGgAZQAg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"
            $dllbytes  = [System.Convert]::FromBase64String($ps)
            $assembly = [System.Reflection.Assembly]::Load($dllbytes)
        }

        $scanner = [PortScanner_Dll.Scanner.TCPConnectScanner]::PerformTCPConnectScan("$IPaddress","$Ports","$Delay","$maxQueriesPS")
        $scanner.Results

    }
}

