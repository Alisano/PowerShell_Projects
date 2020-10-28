#Author Alexander Popov
#This script help you change attributes value of xml1 file to value of xml2 file

#BranchNodes is function that returns list of xPath of all attributes of the xml file
function BranchNodes{
    param ($node, $path)
	if ( !$($node.ChildNodes) ) { echo "$path" }
	foreach ($childNode in $node.ChildNodes){
        if (($($childNode.LocalName) -eq "#comment") ) { Continue }
        if (!$($childNode.ChildNodes)) {
            if ($($childNode.key) -ne $null) { BranchNodes -node $childNode -path $path"/$($childNode.LocalName)[@key=""$($childNode.key)""]" }
            elseif ($($childNode.LocalName) -eq "#text") { echo "$path"; Continue}
            else { BranchNodes -node $childNode -path $path"/$($childNode.LocalName)" }
        }
        else { BranchNodes -node $childNode -path $path"/$($childNode.LocalName)" }
	}
}

#ReplaceAttributes is function for repalce attributes value of xml1 to value of xml2 file
function ReplaceAttributes {
    param ($xml1, $xml2, $branch_nodes_list, $xml1_path)
    foreach ($node_xpath in $branch_nodes_list){
        $node_xml1=$xml1.SelectSingleNode($node_xpath)
        $node_xml2=$xml2.SelectSingleNode($node_xpath)
        foreach ($attribute in $node_xml2.Attributes){
            $node_xml1.SetAttribute($attribute.name, $attribute.value)
            $xml1.save($xml1_path)
        }
        if ($($node_xml1.'#text') -ne $null) {$node_xml1.InnerText = $node_xml2.InnerText; $xml1.save($xml1_path)}
        
    }
}

#this is xpath checker for compare xpath attributes of different xml files
function XPathChecker {
    param ($list, $xml)
    foreach ($node_xpath in $list){
        $node_xml1=$xml1.SelectSingleNode($node_xpath)
        if ($node_xml1 -eq $null) {
            write-host "$node_xpath is incorrect"
        }
    }      
}
# Here is initialize xml objects and function call
$xml1_path = "<path_to_xml1>"
[xml]$xml1 = (Get-Content $xml1_path)

$xml2_path = "<path_to_xml2>"
[xml]$xml2 = (Get-Content $xml2_path)

$path = "<xpath where you start search differents attriobutes of two xml configs>"
$branch_nodes_list = BranchNodes -node $($xml1.configuration) -path $path
ReplaceAttributes -xml1 $xml1 -xml2 $xml2 -branch_nodes_list $branch_nodes_list -xml1_path $xml1_path

XPathChecker -list $branch_nodes_list -xml $xml1