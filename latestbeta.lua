-- BETA_Empereanimate_1 (BE1)

-- > This script doesn't have a server yet, but it will very soon! < --
-- > This is optimized and won't cause you any FPS drops. If there are any it's most probably caused by another one!

-- Subject to change, not everything here is final. Especially because this is a beta!
-- For any bugs, contact me through HAX or Genesis. @zhgf
-- Made by Emper - zhgf#0
-- Don't obfuscate ( The reanimation ) or remove credits.
-- Open sourced, don't steal the code.
-- For any help: Don't ask in DMs, ping me in HAX and I will be glad to answer once I'm free
-- Remember to put the reanimate and the convert script in the same one. REANIMATE GOES FIRST, THE SCRIPT GOES AFTER!
-- Have fun <3

--[[
PFAQ:

Q: "How do I change the hats?"
A: This question will be answered in RELEASE_Empereanimate_1

Q: "How do I align the hats to a sword, object...?"
A: table.insert(Aligns, { AccessoryHandle, BasePart, CFramenew(0, 1, 0) }) -- ( Do not put in a loop and after the reanimation!)

Q: "My body doesn't appear!"
A: Make sure you're wearing the hats and that the reanimation isn't erroring, or if you don't have access to sethiddenproperty (In Studio) then wait 1-2 minutes till your body starts appearing. ( Claiming )

Q: "Does this work with R15?"
A: Yes, but the Rig will always be R6.

Q: "Can I use this in my hub, script...?"
A: As long as credits are present, yes. ( They need to be very clear! ) Example: -- This script uses Empereanimate, made by Emper - zhgf#0

Q: "When will fling be added?" - rqz
A: In another BETA, but you can be sure that it will be in RELEASE_Empereanimate_1

]]

--[[
	Hats: ( These are to make the body. )

	100 - Spikey Coil ( https://www.roblox.com/catalog/13610855206/Spikey-Coil-Troll-Gear
	80 - Rectangle Head ( https://www.roblox.com/catalog/12876444737/Rectangle-Head-Grey
	80 - Rectangle Head ( https://www.roblox.com/catalog/11159410305/Rectangle-Head-For-Headless
	90 - Rectangle Head ( https://www.roblox.com/catalog/11159483910/Rectangle-Head-For-Headless
	50 - [1.0] Extra Noob Torso ( https://www.roblox.com/catalog/14085050294/1-0-Extra-Noob-Torso
]]

if not game:IsLoaded() then
	game.Loaded:Wait()
end

local Aligns = { }
local Accessories = { }
local Attachments = { }

local Instancenew = Instance.new

local taskwait = task.wait
local taskspawn = task.spawn
local taskdefer = task.defer

local mathcos = math.cos
local mathrandom = math.random

local stringmatch = string.match

local osclock = os.clock

local tableinsert = table.insert
local tableclear = table.clear

local CFramenew = CFrame.new
local CFrameAngles = CFrame.Angles
local CFrameidentity = CFrame.identity

local Vector3new = Vector3.new
local Vector3zero = Vector3.zero

local Sleep = CFrameidentity
local Angular = 0
local Linear = 0

local Workspace = game:FindFirstChildOfClass("Workspace")
local CurrentCamera = Workspace.CurrentCamera

local Players = game:FindFirstChildOfClass("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Character = LocalPlayer.Character
local CharacterClone = Instancenew("Model")

local function Part(Name, Size)
	local Part = Instancenew("Part")
	Part.Name = Name
	Part.Size = Size
	Part.Transparency = 1
	Part.Parent = CharacterClone

	return Part
end

local function Motor6D(Name, Part0, Part1, C0, C1)
	local Motor6D = Instancenew("Motor6D")
	Motor6D.Name = Name
	Motor6D.Part0 = Part0
	Motor6D.Part1 = Part1
	Motor6D.C0 = C0
	Motor6D.C1 = C1
	Motor6D.Parent = Part0

	return Motor6D
end

local function Attachment(Name, CFrame, Parent)
	local Attachment = Instancenew("Attachment")
	Attachment.Name = Name
	Attachment.CFrame = CFrame
	Attachment.Parent = Parent

	tableinsert(Attachments, Attachment)
	return Attachment
end

local function FindInstance(Parent, ClassName, Name)
	for _, Instance in pairs(Parent:GetChildren()) do
		if Instance:IsA(ClassName) and Instance.Name == Name then
			return Instance
		end
	end
end

local function WaitForClass(Parent, ClassName)
	local Instance = Parent:FindFirstChildOfClass(ClassName)

	while not Instance and Parent do
		Parent.ChildAdded:Wait()
		Instance = Parent:FindFirstChildOfClass(ClassName)
	end

	return Instance
end

local function WaitForClassOfName(Parent, ...)
	local Instance = FindInstance(Parent, ...)

	while not Instance and Parent do
		Parent.ChildAdded:Wait()
		Instance = FindInstance(Parent, ...)
	end

	return Instance
end

local LimbSize = Vector3new(1, 2, 1)
local TorsoSize = Vector3new(2, 2, 1)

local Head = Part("Head", Vector3new(2, 1, 1))
local Torso = Part("Torso", TorsoSize)
local LeftArm = Part("Left Arm", LimbSize)
local RightArm = Part("Right Arm", LimbSize)
local LeftLeg = Part("Left Leg", LimbSize)
local RightLeg = Part("Right Leg", LimbSize)
local HumanoidRootPart = Part("HumanoidRootPart", TorsoSize)

local Part = nil

if Character then
	Part = FindInstance(Character, "BasePart", "HumanoidRootPart") or FindInstance(Character, "BasePart", "Head") or FindInstance(Character, "BasePart", "Torso") or FindInstance(Character, "BasePart", "UpperTorso")
end
	
if Part then
	HumanoidRootPart.CFrame = Part.CFrame
else
	local SpawnLocations = { }

	for _, SpawnLocation in pairs(Workspace:GetDescendants()) do
		if SpawnLocation:IsA("SpawnLocation") then
			tableinsert(SpawnLocations, SpawnLocation)
		end
	end

	local Amount = # SpawnLocations

	if Amount > 0 then
		local SpawnLocation = SpawnLocations[mathrandom(1, Amount)]
		HumanoidRootPart.CFrame = SpawnLocation.CFrame * CFramenew(0, SpawnLocation.Size.Y / 2 + 3, 0)
	else
		HumanoidRootPart.CFrame = CFrameidentity
	end
end

local face = Instancenew("Decal")
face.Name = "face"
face.Parent = Head

local AccessoryTable = { 
	{ Mesh = "14085008200", Texture = "14085008225", Instance = Torso },
	{ Mesh = "13610799467", Texture = "13610799583", Instance = RightArm, CFrame = CFrameAngles(1.57, 0, 0) },
	{ Mesh = "11159370334", Texture = "11159284657", Instance = LeftArm, CFrame = CFrameAngles(0, 1.57, 1.57) },
	{ Mesh = "11263221350", Texture = "11263219250", Instance = RightLeg, CFrame = CFrameAngles(0, - 1.57, 1.57) },
	{ Mesh = "11159370334", Texture = "11159285454", Instance = LeftLeg, CFrame = CFrameAngles(0, 1.57, 1.57) },
}

Motor6D("Right Shoulder", Torso, RightArm, CFramenew(1, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0), CFramenew(-0.5, 0.5, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0))
Motor6D("Left Shoulder", Torso, LeftArm, CFramenew(-1, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0), CFramenew(0.5, 0.5, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0))
Motor6D("Right Hip", Torso, RightLeg, CFramenew(1, -1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0), CFramenew(0.5, 1, 0, 0, 0, 1, 0, 1, 0, -1, -0, -0))
Motor6D("Left Hip", Torso, LeftLeg, CFramenew(-1, -1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0), CFramenew(-0.5, 1, 0, -0, -0, -1, 0, 1, 0, 1, 0, 0))
Motor6D("Neck", Torso, Head, CFramenew(0, 1, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0), CFramenew(0, -0.5, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0))
Motor6D("RootJoint", HumanoidRootPart, Torso, CFramenew(0, 0, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0), CFramenew(0, 0, 0, -1, -0, -0, 0, 0, 1, 0, 1, 0))

Attachment("HairAttachment", CFramenew(0, 0.600000024, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("HatAttachment", CFramenew(0, 0.600000024, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("FaceFrontAttachment", CFramenew(0, 0, -0.600000024, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("FaceCenterAttachment", CFramenew(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Head)
Attachment("NeckAttachment", CFramenew(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("BodyFrontAttachment", CFramenew(0, 0, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("BodyBackAttachment", CFramenew(0, 0, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("LeftCollarAttachment", CFramenew(-1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("RightCollarAttachment", CFramenew(1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("WaistFrontAttachment", CFramenew(0, -1, -0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("WaistCenterAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("WaistBackAttachment", CFramenew(0, -1, 0.5, 1, 0, 0, 0, 1, 0, 0, 0, 1), Torso)
Attachment("LeftShoulderAttachment", CFramenew(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), LeftArm)
Attachment("LeftGripAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), LeftArm)
Attachment("RightShoulderAttachment", CFramenew(0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), RightArm)
Attachment("RightGripAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), RightArm)
Attachment("LeftFootAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), LeftLeg)
Attachment("RightFootAttachment", CFramenew(0, -1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), RightLeg)
Attachment("RootAttachment", CFramenew(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1), HumanoidRootPart)

local Humanoid = Instancenew("Humanoid", CharacterClone)
Instancenew("Animator", Humanoid)

CharacterClone.PrimaryPart = Head
CharacterClone.Parent = Workspace

local function DescendantAdded(Instance)
	if Instance:IsA("Accessory") then
		taskspawn(function()
			local Handle = WaitForClassOfName(Instance, "BasePart", "Handle")

			if Handle then
				local Attachment = WaitForClass(Handle, "Attachment")

				if Attachment then
					local Clone = Instance:Clone()
					local CloneHandle = FindInstance(Clone, "BasePart", "Handle")

					CloneHandle.Transparency = 1
					CloneHandle:BreakJoints()

					local AccessoryWeld = Instancenew("Weld")
					AccessoryWeld.Name = "AccessoryWeld"
					AccessoryWeld.Part0 = CloneHandle
					AccessoryWeld.C0 = Attachment.CFrame

					local Name = Attachment.Name

					for _, TableAttachment in pairs(Attachments) do
						if TableAttachment.Name == Name then
							AccessoryWeld.Part1 = TableAttachment.Parent
							AccessoryWeld.C1 = TableAttachment.CFrame
						end
					end

					AccessoryWeld.Parent = CloneHandle
					Clone.Parent = CharacterClone

					tableinsert(Accessories, Clone)

					local Part1 = CloneHandle
					local CFrame = CFrameidentity

					local IsAMeshPart = CloneHandle:IsA("MeshPart")
					local Mesh = IsAMeshPart and CloneHandle or WaitForClass(CloneHandle, "SpecialMesh")
					local Id = IsAMeshPart and "TextureID" or "TextureId"

					for _, Table in pairs(AccessoryTable) do
						if stringmatch(Mesh.MeshId, Table.Mesh) and stringmatch(Mesh[Id], Table.Texture) then
							Part1 = Table.Instance
							CFrame = Table.CFrame or CFrame
						end
					end

					tableinsert(Aligns, { Handle, Part1, CFrame })
				end
			end
		end)
	elseif Instance:IsA("JointInstance") then
		taskdefer(Instance.Destroy, Instance)
	end
end

local function CharacterAdded(Character)
	if Character ~= CharacterClone then
		taskwait()
		tableclear(Aligns)

		for _, Accessory in pairs(Accessories) do
			Accessory:Destroy()
		end

		local CurrentCameraCFrame = CurrentCamera.CFrame

		LocalPlayer.Character = nil
		LocalPlayer.Character = CharacterClone

		CurrentCamera.CameraSubject = Humanoid

		taskspawn(function()
			CurrentCamera:GetPropertyChangedSignal("CFrame"):Wait()
			CurrentCamera.CFrame = CurrentCameraCFrame
		end)

		WaitForClassOfName(Character, "BasePart", "HumanoidRootPart").CFrame = HumanoidRootPart.CFrame * CFramenew(mathrandom(- 32, 32), 0, mathrandom(- 32, 32))
		taskwait()
		Character:BreakJoints()

		for _, Instance in pairs(Character:GetDescendants()) do
			DescendantAdded(Instance)
		end

		Character.DescendantAdded:Connect(DescendantAdded)
	end
end

local function Align(Part0, Part1, CFrame)
	if Part0.ReceiveAge == 0 and not Part0.Anchored and # Part0:GetJoints() == 0 then
		Part0.AssemblyAngularVelocity = Part1.AssemblyAngularVelocity + Vector3new(Angular, Angular, Angular)

		local Part1CFrame = Part1.CFrame
		local LinearVelocity = Part1.AssemblyLinearVelocity * Linear
		local Magnitude = LinearVelocity.Magnitude < Linear

		if Magnitude then
			local LookVector = Part1CFrame.LookVector * Linear
			Part0.AssemblyLinearVelocity = Vector3new(LookVector.X, - Linear, LookVector.Z)
		else
			Part0.AssemblyLinearVelocity = Vector3new(LinearVelocity.X, Linear, LinearVelocity.Z)
		end

		Part0.CFrame = Part1CFrame * Sleep * CFrame
	end
end

if Character then
	CharacterAdded(Character)
end

local Added = LocalPlayer.CharacterAdded:Connect(CharacterAdded)

local Connection = game:FindFirstChildOfClass("RunService").PostSimulation:Connect(function()
	local osclock = osclock() * 100
	local Axis = 0.001 * mathcos(osclock)

	Sleep = CFramenew(Axis, 0, 0)
	Angular = mathcos(osclock)
	Linear = 26 + Angular

	for _, Table in pairs(Aligns) do
		Align(Table[1], Table[2], Table[3])
	end

	if sethiddenproperty then
		sethiddenproperty(LocalPlayer, "SimulationRadius", 10000000)
	end
end)

CharacterClone:GetPropertyChangedSignal("Parent"):Connect(function()
	if not CharacterClone.Parent then
		Added:Disconnect()
		Connection:Disconnect()
		CharacterClone:Destroy()
	end
end)
