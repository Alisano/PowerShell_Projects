#Author Alexander Popov
#This script help you install windows feature and modules for your environment 
#=========================install windows feature==================================
Add-WindowsFeature  "<windows_feature_name>"
#=========================install global modules===================================
$global_modules_list = @(
	@{ name = "<global_modules_name>"; image = "<image_path>"; preCondition = "<true or false>" }; 
	#and here you can add other hashtable of global_modules_list
)

foreach($module in $global_modules_list){
    if ($module.preCondition){
        Add-WebConfigurationProperty //globalModules -Name collection -Value @{name="$($module.name)";image="$($module.image)";preCondition="$($module.preCondition)"} -PSPath IIS:\
    } else {
        Add-WebConfigurationProperty //globalModules -Name collection -Value @{name="$($module.name)";image="$($module.image)"} -PSPath IIS:\
    }
}
#=========================install modules===================================
$modules_list = @(
	@{ name = "<module_name>"; type = "<true or false>"; lockItem = "<true or false>"; preCondition = "<true or false>" }; 
	#and here you can add other hashtable of modules_list
)

foreach($module in $modules_list){
    if($modules_list.lockItem) {
        Add-WebConfigurationProperty //modules -Name collection -Value @{name="$($module.name)";lockItem="true"} -PSPath IIS:\
    }
    elseif ($modules_list.preCondition) {
        Add-WebConfigurationProperty //modules -Name collection -Value @{name="$($module.name)";type="$($module.type)";preCondition="$($module.preCondition)"} -PSPath IIS:\
    } 
    else {
        Add-WebConfigurationProperty //modules -Name collection -Value @{name="$($module.name)"} -PSPath IIS:\
    }
}