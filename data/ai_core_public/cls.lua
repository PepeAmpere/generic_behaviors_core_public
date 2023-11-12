return {
    cls = {
        -- @description Creates a search table and array of all available classes
        BuildClasses = function()
            local mapOfClasses = {}
            local arrayOfClasses = {}
            
            for _, btsetName in ipairs(GetBTSetNames()) do
                local btsetClasses = _ENV[btsetName].classes or {}

                for i=1, #btsetClasses do
                    local className = btsetClasses[i]
                    local classDefinition = _ENV[btsetName][className] or {}

                    if cls.Valid(classDefinition) then
                        mapOfClasses[className] = classDefinition
                        mapOfClasses[className].btsetName = btsetName
                        mapOfClasses[className].className = className
                    end
                end                
            end

            local function AddClassInArray(className)
                local nextIndex = #arrayOfClasses + 1
                arrayOfClasses[nextIndex] = className
                mapOfClasses[className].index = nextIndex
            end

            -- pick root classes first
            local nonRootCount = 0
            local resolved = {}
            for className, classDefinition in pairs(mapOfClasses) do
                if classDefinition.parents == nil then
                    AddClassInArray(className)
                    resolved[className] = true
                else
                    nonRootCount = nonRootCount + 1
                    resolved[className] = false
                end
            end

            -- ordering will reflect the less specific classes are the first
            for i=1, nonRootCount do -- iterate max as many times as many remaining nonRoot classes
                local anyChange = false
                for className, classDefinition in pairs(mapOfClasses) do
                    if not resolved[className] then
                        local parents = classDefinition.parents
                        local parentsOk = true

                        for j=1, #parents do
                            local parentName = parents[j]
                            if 
                                mapOfClasses[parentName] and
                                not resolved[parentName]
                            then
                                parentsOk = false
                                break                                
                            end
                        end

                        if parentsOk then 
                            AddClassInArray(className)
                            resolved[className] = true
                            anyChange = true
                        end
                    end
                end

                if not anyChange then
                    break
                end
            end

            return arrayOfClasses, mapOfClasses
        end,

        -- @description Returns the last matching class
        MatchClass = function()
            local arrayOfClasses, mapOfClasses = cls.BuildClasses()
            local lastMatchName = ""

            for i=1, #arrayOfClasses do
                local className = arrayOfClasses[i]
                local classDefinition = mapOfClasses[className]
                local readyForMatching = true

                if 
                    classDefinition.Match() 
                then
                    lastMatchName = className
                end
            end

            bb.arrayOfClasses = arrayOfClasses
            bb.mapOfClasses = mapOfClasses
            return mapOfClasses[lastMatchName]
        end,

        -- @description returns behavior path        
        -- @argument classDefinition [table] definition of the class defined in addon
        -- @argument orderName [string] name of the order given
        GetBehaviorPath = function(classDefinition, orderName)
            return {
                classDefinition.btsetName,
                classDefinition.behaviors[orderName].tree
            }
        end,

        -- @description Does some basic checks on the class definition
        -- @argument classDefinition [table] definition of the class defined in addon
        Valid = function(classDefinition)
            if classDefinition.Match == nil then return false end
            if classDefinition.behaviors == nil then return false end
            if classDefinition.simpleClass ~= true then return false end
            return true
        end,
    }
}