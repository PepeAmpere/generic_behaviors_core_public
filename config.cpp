#include "\vbs2\basic_defines.hpp"
#define __CurrentDir__ \vbs2\customer\plugins\ai_core_public\

//Class necessary for VBS to load the new addon correctly
class CfgPatches
{
	class vbs2_vbs_plugins_ai_core_public
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.10;
		requiredAddons[] = {
			vbs2_editor, 
			vbs2_people,
			vbs2_plugins_function_library,
			vbs2_vbs_plugins_standard_behaviors
		};
		modules[] =
		{
			vbs_core_content_module
		};
	};
};

// Adds btset to list of btsets which are loaded automatically
class CfgBehaviorTrees
{
	class ai_core_public //this is an arbitrary className, it needs to be unique though
	{
		path = "\vbs2\customer\plugins\ai_core_public\data\ai_core_public\ai_core_public.btset"; //This is the relative path to the BT-set file to load
		name = "ai_core_public"; // This is the btset name duplicated in the configuration
	};
};

class vbs_functions_base;
class CfgFunctions
{
	// Macro to build a function in sripts top folder
	#define MAKE_CORE_FUNCTION(functionName)                                 \
	class fn_vbs_ai_core_public_##functionName : vbs_functions_base                     \
	{                                                                       \
		path = __CurrentDir__\data\scripts\fn_vbs_ai_core_public__##functionName##.sqf;  \
	}

};