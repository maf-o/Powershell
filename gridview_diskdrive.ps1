#Got script from https://mcpmag.com/articles/2016/02/17/creating-a-gui-using-out-gridview.aspx


$WMI =  @{

  Filter =  "DriveType='3' AND (Not Name LIKE  '\\\\?\\%')"

  Class =  "Win32_Volume"

  ErrorAction =  "Stop"

  Property =  "Name","Label","Capacity","FreeSpace"

  Computername =  $Env:COMPUTERNAME

}

$List = New-Object System.Collections.ArrayList

  Get-WmiObject @WMI  | ForEach {

  $Decimal  = $_.freespace / $_.capacity

  $Graph  = "$($Bar)"*($Decimal*100)

  $Hash = [ordered]@{

  Computername =  $Env:COMPUTERNAME

  Name =  $_.Name

  FreeSpace =  "$Graph"       

  Percent =  $Decimal

  FreeSpaceGB =  ([math]::Round(($_.Freespace/1GB),2))

  CapacityGB =  ([math]::Round(($_.Capacity/1GB),2))

  }

  [void]$List.Add((

  [pscustomobject]$Hash

  ))

  }

$List | Out-GridView -Title 'Drive Space' 