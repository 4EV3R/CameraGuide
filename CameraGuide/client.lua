--░░██╗██╗███████╗██╗░░░██╗██████╗░██████╗░
--░██╔╝██║██╔════╝██║░░░██║╚════██╗██╔══██╗
--██╔╝░██║█████╗░░╚██╗░██╔╝░█████╔╝██████╔╝
--███████║██╔══╝░░░╚████╔╝░░╚═══██╗██╔══██╗
--╚════██║███████╗░░╚██╔╝░░██████╔╝██║░░██║
--░░░░░╚═╝╚══════╝░░░╚═╝░░░╚═════╝░╚═╝░░╚═╝

local createdCamera = 0

function ChangeGuideCamera(x, y, z, r)
    if createdCamera ~= 0 then
        DestroyCam(createdCamera, 0)
        createdCamera = 0
    end
    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamCoord(cam, x, y, z)
    SetCamRot(cam, r.x, r.y, r.z, 2)
    RenderScriptCams(1, 0, 0, 1, 1)
    Wait(250)
    createdCamera = cam
end

function CloseGuideCamera()
    DestroyCam(createdCamera, 0)
    RenderScriptCams(0, 0, 1, 1, 1)
    createdCamera = 0
    SetFocusEntity(GetPlayerPed(PlayerId()))
    FreezeEntityPosition(GetPlayerPed(PlayerId()), false)
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentSubstringPlayerName(text)
    DrawNotification(false, false)
end

function NextUp()
    local secTime = Config.TimeSec * 1000
    Citizen.Wait(100)
    DoScreenFadeIn(1000)
    Citizen.Wait(secTime + 1000)
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
end

function Guide ()
    DoScreenFadeOut(1000)
    Citizen.Wait(1000)
	DisplayRadar(false)

    SetFocusArea(Config.FirstCam.x, Config.FirstCam.y, Config.FirstCam.z)
    ChangeGuideCamera(Config.FirstCam.x, Config.FirstCam.y, Config.FirstCam.z, Config.FirstCamRot)
    ShowNotification(Config.Notifs[1])
    NextUp()

    SetFocusArea(Config.SecondCam.x, Config.SecondCam.y, Config.SecondCam.z)
    ChangeGuideCamera(Config.SecondCam.x, Config.SecondCam.y, Config.SecondCam.z, Config.SecondCamRot)
    ShowNotification(Config.Notifs[2])
    NextUp()

    SetFocusArea(Config.ThirdCam.x, Config.ThirdCam.y, Config.ThirdCam.z)
    ChangeGuideCamera(Config.ThirdCam.x, Config.ThirdCam.y, Config.ThirdCam.z, Config.ThirdCamRot)
    ShowNotification(Config.Notifs[3])
    NextUp()

    SetFocusArea(Config.FourthCam.x, Config.FourthCam.y, Config.FourthCam.z)
    ChangeGuideCamera(Config.FourthCam.x, Config.FourthCam.y, Config.FourthCam.z, Config.FourthCamRot)
    ShowNotification(Config.Notifs[4])
    NextUp()

    SetFocusArea(Config.FirstCam.x, Config.FirstCam.y, Config.FirstCam.z)
    ChangeGuideCamera(Config.FirstCam.x, Config.FirstCam.y, Config.FirstCam.z, Config.FirstCamRot)
    ShowNotification(Config.Notifs[5])
    NextUp()

    CloseGuideCamera()
    DoScreenFadeIn(1000)
    SetEntityCoords(PlayerPedId(), Config.BackSpawn.x, Config.BackSpawn.y, Config.BackSpawn.z, Config.BackSpawn.w, 0, 0, false)
    DisplayRadar(true)
end

----------------------Drawmarker---------------------------------
local function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end

local function setupScaleform(scaleform, BRString, button)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
	if button ~= nil then
		Button(GetControlInstructionalButton(2, 38, true))
	end
    ButtonMessage(BRString)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

Citizen.CreateThread(function()
    while true do 
	Citizen.Wait(0)
	local InZone = false
	local distance = #(GetEntityCoords(PlayerPedId()) - Config.MarkerLoc

        if distance < 105.0 then
		InZone = true
	end
        if distance < 100.0 then
            DrawMarker(32, Config.MarkerLoc, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 130, 200, 200, true, true, 2, true, false, false, false)
            if #(GetEntityCoords(PlayerPedId()) - Config.MarkerLoc) < 2.0 then
                enterForm = setupScaleform("instructional_buttons", "View Guide", 38)
                DrawScaleformMovieFullscreen(enterForm, 255, 255, 255, 255, 0)
                if IsControlJustReleased(2, 38) then
                    Guide()
                end
            end
        end
	if InZone then
		Citizen.Wait(0)
	else
		Citizen.Wait(1000)
	end
    end
end)
