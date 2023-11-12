return {
    Base = {

        description = "Fallback group",
        simpleClass = true,

        Match = function()
            return true
        end,

        behaviors = {

            Advance = {tree = 'Default'},
            Idle = {tree = 'Default'},

        },
    },
}