#Author Alexander Popov
#Here is example how add the row in the table in xml file

#Here is fuction that returns image link
function Get-Image{
    $image = '<image_link>'
    return $image
}

#This function add new row in the table in xml file
function Add-Row{
    param (
        $xml = [xml](Get-Content "<xml_path>"),
		$SomeЕext
    ) 
    $table = $xml.table.tbody
    $row = $xml.CreateNode("element","tr","")
    $column = $xml.CreateNode("element","td","")
    $column.InnerXML = Get-Image
    $row.AppendChild($column)
    $table.AppendChild($row)
    #you can make serveral column as this
	$column2 = $xml.CreateNode("element","td","")
    $status = $xml.CreateTextNode($SomeЕext)
    $row.AppendChild($column2)
    $column2.AppendChild($status)
    $xml.save("<path_to_save_xml_file>")
}

#Here you can call Add-Row function
Add-Row $xml $SomeЕext