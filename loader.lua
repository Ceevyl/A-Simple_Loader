local cycles = {}

cycles.__index = cycles;

cycles.__call = function( self )

    if getmetatable(self) then

        setmetatable(self, nil);

    end    

    for k in pairs(self) do

        self[k] = nil;

    end;

    return collectgarbage();
end

function CreateLoader( ... )

    local self = setmetatable({}, cycles)

    self.constructor = function(self, ...)

        if #({...}) < 0 or type(self) ~= 'table' then

            return false, error(  #({...}) < 0 and "Required Arguments" or "Table Not Found"  );

        end
            
        self.Params = {...}

        self.CreatedSvg = svgCreate( self.Params[3], self.Params[4], [[<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512"><!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --><path d="M304 48a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zm0 416a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zM48 304a48 48 0 1 0 0-96 48 48 0 1 0 0 96zm464-48a48 48 0 1 0 -96 0 48 48 0 1 0 96 0zM142.9 437A48 48 0 1 0 75 369.1 48 48 0 1 0 142.9 437zm0-294.2A48 48 0 1 0 75 75a48 48 0 1 0 67.9 67.9zM369.1 437A48 48 0 1 0 437 369.1 48 48 0 1 0 369.1 437z"/></svg>]])

        self.count = 0;

        self.ConfigInterpol = {
            ticks = 0;
            ini = 0;
            fim = 255;
        }

        self.dxRender = function()

            local i = interpolateBetween(  self.ConfigInterpol.ini , 0, 0, self.ConfigInterpol.fim , 0, 0, ( getTickCount()-self.ConfigInterpol.ticks )/1000, "Linear"  )
    
            
            dxDrawImage(self.Params[1], self.Params[2], self.Params[3], self.Params[4] ,  self.CreatedSvg , self.count, 0, 0, tocolor(255, 255, 255, i))
          
            self.count = self.count + self.Params[5]

            if self.count >= 360 then

                self.count = 0;

            end;

            if i >= 255 then

                self.ConfigInterpol.ini = 255;
                self.ConfigInterpol.fim = 0;

                self.ConfigInterpol.ticks = getTickCount();

            elseif ( i <= 0 ) then

                self.ConfigInterpol.ini = 0;
                self.ConfigInterpol.fim = 255;

                self.ConfigInterpol.ticks = getTickCount();

            end;

        end;

        self.startRender = function()

            return addEventHandler("onClientRender", root, self.dxRender, true, 'low-5');

        end;

        self.stopRender = function()

            return removeEventHandler("onClientRender", root, self.dxRender);

        end;

    end;

    self.GetConfiguredValues = function(self)
        return self;
    end;

    self.TurnLoader = function(self, ModeToTurn)

        if not ModeToTurn or not ( type(ModeToTurn) == "string" ) then

            return false;

        end

        local recalc = ModeToTurn:lower();

        return ( recalc == "on" and self.startRender() or self.stopRender() );

    end;

    self.TurnOffLoader = function(self)
        return self.stopRender();
    end

    self:constructor(...)

    return self;
end

local a = CreateLoader( 1000/2, 768/2, 50, 50, 2 )

function createEvent(event, ...)
    addEvent(event, true)
    addEventHandler(event, ...);
end

createEvent("turnLoader", root, 

    function( turned )

        a:TurnLoader(turned);

    end

)

