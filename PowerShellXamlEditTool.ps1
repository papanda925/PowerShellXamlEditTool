
using namespace System.Collections.ObjectModel #ObservableCollection
using namespace System.ComponentModel #SortDescription]
using namespace System.Collections.Generic
using namespace System.Windows.Data

#Start-Transcript ((Get-Location).Path + "\XamlEventList.txt")  -Append

Set-PSDebug -Strict
Add-Type -AssemblyName PresentationFramework
Add-Type -Assembly System.Windows.Forms
Add-Type -Assembly System.Collections
Add-Type -AssemblyName system.Dynamic

[xml]$XAML = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title = "window Sample"
    Language="jp-JP" Height="auto" Width="auto">
    <Grid ShowGridLines="True">

    <Grid.ColumnDefinitions >
        <ColumnDefinition Width="*" />
        <ColumnDefinition Width="*" />
    </Grid.ColumnDefinitions>

    <Grid.RowDefinitions>
        <RowDefinition Height="*"/>
        <RowDefinition Height="*"/>
        <RowDefinition Height="0.3*"/>

    </Grid.RowDefinitions>
    <StackPanel Margin="0" Grid.Row="0" Grid.Column="0"  Background="Cornsilk"  >
    </StackPanel>

    <DockPanel Margin="0"  Grid.Row="0" Grid.Column="0" Grid.ColumnSpan="2" >
        <DataGrid Name="DataGrid" 
            AutoGenerateColumns="False" 
            HorizontalScrollBarVisibility ="Visible"
            VerticalScrollBarVisibility = "Visible" >
            <DataGrid.Columns>
                <DataGridTextColumn Header="Index" Binding="{Binding Index}"/>
                <DataGridTextColumn Header="Namespace" Binding="{Binding Namespace}"/>
                <DataGridTextColumn Header="IsPublic" Binding="{Binding IsPublic}"/>
                <DataGridTextColumn Header="Name" Binding="{Binding Name}"/>
                <DataGridTextColumn Header="Attributes" Binding="{Binding Attributes}"/>
                <DataGridTextColumn Header="BaseType" Binding="{Binding BaseType}"/>
                <DataGridTextColumn Header="FullName" Binding="{Binding FullName}"/>
                <DataGridTextColumn Header="ImplementedInterfaces" Binding="{Binding ImplementedInterfaces}"/>
                <DataGridTextColumn Header="Assembliy" Binding="{Binding Assembliy}"/>
            </DataGrid.Columns>
        </DataGrid>
    </DockPanel>

    <DockPanel Margin="0"  Grid.Row="1" Grid.Column="0" Background="Cornsilk" >
        <TabControl Name="TabControl" Margin="20">
            <TabItem Header="Event">
                <DataGrid Name="DataGrid_Event" 
                    AutoGenerateColumns="False" 
                    HorizontalScrollBarVisibility ="Visible"
                    VerticalScrollBarVisibility = "Visible" >
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Index" Binding="{Binding Index}"/>
                        <DataGridTextColumn Header="Name" Binding="{Binding Name}"/>
                        <DataGridTextColumn Header="Definition" Binding="{Binding Definition}"/>
                    </DataGrid.Columns>
                </DataGrid>
            </TabItem>
            <TabItem Header="Method">
                <DataGrid Name="DataGrid_Method" 
                    AutoGenerateColumns="False" 
                    HorizontalScrollBarVisibility ="Visible"
                    VerticalScrollBarVisibility = "Visible" >
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Index" Binding="{Binding Index}"/>
                        <DataGridTextColumn Header="Name" Binding="{Binding Name}"/>
                        <DataGridTextColumn Header="Definition" Binding="{Binding Definition}"/>
                    </DataGrid.Columns>
                </DataGrid>
            </TabItem>
            <TabItem Header="Property">
                <DataGrid Name="DataGrid_Property" 
                    AutoGenerateColumns="False" 
                    HorizontalScrollBarVisibility ="Visible"
                    VerticalScrollBarVisibility = "Visible" >
                    <DataGrid.Columns>
                        <DataGridTextColumn Header="Index" Binding="{Binding Index}"/>
                        <DataGridTextColumn Header="Name" Binding="{Binding Name}"/>
                        <DataGridTextColumn Header="Value" Binding="{Binding Value, Mode=TwoWay}"/>                
                        <DataGridTextColumn Header="Definition" Binding="{Binding Definition}"/>
                    </DataGrid.Columns>
                </DataGrid>
            </TabItem>
        </TabControl>
    </DockPanel>
    <DockPanel Margin="0"  Grid.Row="1" Grid.Column="1"  >
        <DataGrid Name="DataGrid3" 
            AutoGenerateColumns="False" 
            HorizontalScrollBarVisibility ="Visible"
            VerticalScrollBarVisibility = "Visible" >
            <DataGrid.Columns>
                <DataGridTextColumn Header="Target" Binding="{Binding Target}"/>                
                <DataGridTextColumn Header="SampleCode" Binding="{Binding SampleCode}"/>
            </DataGrid.Columns>
        </DataGrid>
    </DockPanel>
    <DockPanel Margin="0"  Grid.Row="2" Grid.Column="0"  Grid.ColumnSpan="2"  >
    <TextBox
        Name="ExceptionTxt"
        TextWrapping="Wrap"
        AcceptsReturn="True"
        Text="{Binding Message,  Mode=TwoWay, UpdateSourceTrigger=PropertyChanged }"
        VerticalScrollBarVisibility="Visible" />
    </DockPanel>
    </Grid>

</Window>
'@


try {

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    $window = [Windows.Markup.XamlReader]::Load($reader)
    
    $window | Add-Member NoteProperty -Name 'DataGrid' -Value $window.FindName('DataGrid') -Force
    $window | Add-Member NoteProperty -Name 'DataGrid_Event' -Value $window.FindName('DataGrid_Event') -Force
    $window | Add-Member NoteProperty -Name 'DataGrid_Method' -Value $window.FindName('DataGrid_Method') -Force
    $window | Add-Member NoteProperty -Name 'DataGrid_Property' -Value $window.FindName('DataGrid_Property') -Force
    $window | Add-Member NoteProperty -Name 'ExceptionTxt' -Value $window.FindName('ExceptionTxt') -Force

    $window | Add-Member NoteProperty -Name 'DataGrid3' -Value $window.FindName('DataGrid3') -Force

    
    $ObservableCollection = New-Object ObservableCollection[System.Dynamic.ExpandoObject]
    $EventObservableCollection = New-Object ObservableCollection[System.Dynamic.ExpandoObject]
    $MethodObservableCollection = New-Object ObservableCollection[System.Dynamic.ExpandoObject]
    $PropertyObservableCollection = New-Object ObservableCollection[System.Dynamic.ExpandoObject]
    
    $ExceptionTxtExpandoObject = [System.Dynamic.ExpandoObject]::new()
    $window.ExceptionTxt.DataContext = $ExceptionTxtExpandoObject
    $ExceptionTxtExpandoObject.Message  = "test"

    $ItemsObservableCollection = New-Object ObservableCollection[System.Dynamic.ExpandoObject]

    $window.DataGrid.ItemsSource = $ObservableCollection
    $window.DataGrid_Event.ItemsSource = $EventObservableCollection
    $window.DataGrid_Method.ItemsSource = $MethodObservableCollection
    $window.DataGrid_Property.ItemsSource = $PropertyObservableCollection
    $window.DataGrid3.ItemsSource = $ItemsObservableCollection

    [int]$index = 0
    $Assemblies = ([AppDomain]::CurrentDomain.GetAssemblies())
    foreach ($Assembliy in $Assemblies.GetTypes()) {
        if ( $Assembliy.Namespace -eq "System.Windows.Controls" ) {
            if( $Assembliy.IsPublic -eq $true ){
                $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
                $index++
                [int]$ExpandoObject.Index = $index
                [string]$ExpandoObject.Namespace =  $Assembliy.Namespace
                [bool]$ExpandoObject.IsPublic =  $Assembliy.IsPublic
                [string]$ExpandoObject.Name =  $Assembliy.Name
                [string]$ExpandoObject.Attributes =  $Assembliy.Attributes    
                [string]$ExpandoObject.BaseType =  $Assembliy.BaseType
                [string]$ExpandoObject.FullName =  $Assembliy.FullName
                [string]$ExpandoObject.ImplementedInterfaces =  $Assembliy.ImplementedInterfaces
                [PSCustomObject]$ExpandoObject.Assembliy = $Assembliy
                $ObservableCollection.Add($ExpandoObject)
            }
        }
    }


    $window.DataGrid.ADD_SelectionChanged{
        $Index = @{}
        [int]$Index["Event"] = 0
        [int]$Index["Method"] = 0
        [int]$Index["Property"] = 0

 
        $EventObservableCollection.Clear()
        $MethodObservableCollection.Clear()
        $PropertyObservableCollection.Clear()

        [string]$s = ($this.SelectedItem.Namespace + "." + $this.SelectedItem.Name)
        try {
            $obj = New-Object $s
            $ret  = ($obj | Get-Member)
            $ret |  Where-Object{
                $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
                $ExpandoObject.TypeName  =  $_.TypeName
                $ExpandoObject.Definition = $_.Definition
                $ExpandoObject.Name  =  $_.Name
                $ExpandoObject.MemberType =  $_.MemberType
                $ExpandoObject.Namespace = $this.SelectedItem.Namespace 
                write-host  ('$obj = New-Object ' + $_.TypeName)
                Invoke-Expression ('$obj = New-Object ' + $_.TypeName)
                $ExpandoObject.obj = $obj

                switch ($_.MemberType) {
                    "Event" 
                    {
                        write-host "Event"
                        $Index["Event"]++
                        $ExpandoObject.Index  =  $Index["Event"]        
                        $EventObservableCollection.add($ExpandoObject)

                    }
                    "Method"
                    {
                        write-host "Method"
                        $Index["Method"]++
                        $ExpandoObject.Index  =  $Index["Method"]        
                        $MethodObservableCollection.add($ExpandoObject)
                    }
                    "Property"
                    {
                        write-host "Property"
                        write-host  ( 'Property $ExpandoObject.Value = $obj.' + $ExpandoObject.Name.ToString())

                        Invoke-Expression ('$ExpandoObject.Value = $obj.' + $ExpandoObject.Name.ToString())
                        $Index["Property"]++
                        $ExpandoObject.Index  =  $Index["Property"]        
                        $PropertyObservableCollection.add($ExpandoObject)
                    }
                    default {"Not matched."}
                }

            } 
            write-host "End"
           
<#
            $ret  = ($obj | Get-Member -MemberType "Event") 
            $ret |  Where-Object{ 
#                Write-Host (" $" + "window.ADD_" + $_.name + "{   write-host """ + $_.name + """ }")

                $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
                $ExpandoObject.TypeName  =  $_.TypeName
                $ExpandoObject.Definition = $_.Definition
                $ExpandoObject.Name  =  $_.Name
                $ExpandoObject.MemberType =  $_.MemberType
                $ExpandoObject.Namespace = $this.SelectedItem.Namespace 
                write-host  ('$obj = New-Object ' + $_.TypeName)
                Invoke-Expression ('$obj = New-Object ' + $_.TypeName)
                $ExpandoObject.obj = $obj

                $index++
                $ExpandoObject.Index  =  $index 
                $EventObservableCollection.add($ExpandoObject)
            }

            $MethodObservableCollection.Clear()
            [int]$index = 0    
            $ret  = ($obj | Get-Member -MemberType "Method") 
            $ret |  Where-Object{ 
#                Write-Host (" $" + "window.ADD_" + $_.name + "{   write-host """ + $_.name + """ }")

                $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
                $ExpandoObject.TypeName  =  $_.TypeName
                $ExpandoObject.Definition = $_.Definition
                $ExpandoObject.Name  =  $_.Name
                $ExpandoObject.MemberType =  $_.MemberType
                $ExpandoObject.Namespace = $this.SelectedItem.Namespace 
                write-host  ('$obj = New-Object ' + $_.TypeName)
                Invoke-Expression ('$obj = New-Object ' + $_.TypeName)
                $ExpandoObject.obj = $obj

                $index++
                $ExpandoObject.Index  =  $index
                $MethodObservableCollection.add($ExpandoObject)
            }
            Write-Host "# ------------------------- Property ------------------------- "

            $PropertyObservableCollection.Clear()
            [int]$index = 0
            $ret  = ($obj | Get-Member -MemberType "Property")
            $ret |  Where-Object{ 
                Write-Host ("#TypeName:   " + $_.TypeName) 
                Write-Host ("#Definition: " + $_.Definition ) 
                Write-Host ("#Name:       " + $_.Name) 
                Write-Host ("#MemberType: " + $_.MemberType) 

#                Write-Host (" $" + "$window.TextBox" + $_.name )
                $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
                $ExpandoObject.TypeName  =  $_.TypeName
                $ExpandoObject.Definition = $_.Definition
                $ExpandoObject.Name  =  $_.Name
                $ExpandoObject.MemberType =  $_.MemberType
                $ExpandoObject.Namespace = $this.SelectedItem.Namespace 
                Invoke-Expression ('$ExpandoObject.Value = $obj.' + $_.Name.ToString())
                #write-host ($Obj.ActualHeight).GetType().FullName
                #$write-host $ExpandoObject.Value.GetType().FullName
                write-host  ('$obj = New-Object ' + $_.TypeName)
                Invoke-Expression ('$obj = New-Object ' + $_.TypeName)
                $ExpandoObject.obj = $obj
                

                $index++
                $ExpandoObject.Index  =  $index
                $PropertyObservableCollection.add($ExpandoObject)

            }
#>
        }
        catch {
            <#Do this if a terminating exception happens#>
            write-host "DataGrid.ADD_SelectionChanged false"
            [String]$ExceptionString = "Exception ADD_SelectionChanged"
            $ExceptionString += "`r`n"
            $ExceptionString += $PSItem.Exception
            write-host $ExceptionString
            $ExceptionTxtExpandoObject.Message = $ExceptionString

        }
    }


    $window.DataGrid_Event.ADD_SelectionChanged{
        $ItemsObservableCollection.clear()
        try {
            $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
            $obj = $this.SelectedItem.obj
            #Invoke-Expression ('$obj = New-Object ' + $this.SelectedItem.TypeName)
            $xaml = [System.Windows.Markup.XamlWriter]::Save($obj)
            write-host  $xaml
            $ExpandoObject.Target = 'Xaml'
            $ExpandoObject.SampleCode =  $xaml
            $ItemsObservableCollection.add($ExpandoObject)
            
            $window = New-Object System.Windows.Window
            $window.AddChild($obj)
            $xaml = [System.Windows.Markup.XamlWriter]::Save($window)
            write-host  $xaml
            $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
            $ExpandoObject.Target = 'Xaml In Wimdow'
            $ExpandoObject.SampleCode =  $xaml
            $ItemsObservableCollection.add($ExpandoObject)
        }
        catch {
            <#Do this if a terminating exception happens#>
            write-host "SrcDataGrid ADD_SelectionChanged false"

            [String]$ExceptionString = "Exception"
            $ExceptionString += "`r`n"
            $ExceptionString += $PSItem.Exception
            write-host $ExceptionString
            $ExceptionTxtExpandoObject.Message = $ExceptionString
            [void][System.Windows.Forms.MessageBox]::Show($ExceptionString, $PSItem.Exception.Source, "OK", "Error")
        }

    }

    $window.DataGrid_Property.ADD_SelectionChanged{
        $ItemsObservableCollection.clear()
        try {
#            $ExpandoObject = [System.Dynamic.ExpandoObject]::new()

            $obj = $this.SelectedItem.obj
            #write-host $this.SelectedItem.TypeName
            #write-host $this.SelectedItem.Definition
            #write-host $this.SelectedItem.Name
            #write-host $this.SelectedItem.MemberType
            #write-host $this.SelectedItem.Namespace
            #write-host $this.SelectedItem.Value

            Write-Host $this.SelectedItem.Value.GetType().FullName

            $s = $this.SelectedItem.Value.GetType().FullName
            if( $this.SelectedItem.Value -ne '' )
            {
                $s = ('$obj.' + $this.SelectedItem.Name + ' = ' + $this.SelectedItem.Value)
                Write-Host $s
                Invoke-Expression ($s)    
            }


            $xaml = [System.Windows.Markup.XamlWriter]::Save($obj)
            write-host  $xaml
            $ExpandoObject.Target = 'Xaml'
            $ExpandoObject.SampleCode =  $xaml
            $ItemsObservableCollection.add($ExpandoObject)
            
            $window = New-Object System.Windows.Window
            $window.AddChild($obj)
            $xaml = [System.Windows.Markup.XamlWriter]::Save($window)
            write-host  $xaml
            $ExpandoObject = [System.Dynamic.ExpandoObject]::new()
            $ExpandoObject.Target = 'Xaml In Wimdow'
            $ExpandoObject.SampleCode =  $xaml
            $ItemsObservableCollection.add($ExpandoObject)
        }
        catch {
            <#Do this if a terminating exception happens#>
            write-host "SrcDataGrid ADD_SelectionChanged false"
            [String]$ExceptionString = "Exception"
            $ExceptionString += "`r`n"
            $ExceptionString += $PSItem.Exception
            write-host $ExceptionString
            $ExceptionTxtExpandoObject.Message = $ExceptionString
            #[void][System.Windows.Forms.MessageBox]::Show($ExceptionString, $PSItem.Exception.Source, "OK", "Error")
        }
      

    }






    $window.ShowDialog()
}
catch {
    <#Do this if a terminating exception happens#>
    [String]$ExceptionString = "Exception"
    $ExceptionString += "`r`n"
    $ExceptionString += $PSItem.Exception
    write-host $ExceptionString
    $ExceptionTxtExpandoObject.Message = $ExceptionString

    [void][System.Windows.Forms.MessageBox]::Show($ExceptionString, $PSItem.Exception.Source, "OK", "Error")
    # Write-Output $ExceptionString | Out-File -Encoding default -Append ((Get-Location).Path + "\MaGaTechDebuglog.txt")

}
finally {
    <#Do this after the try block regardless of whether an exception occurred or not#>
}
