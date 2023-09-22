-- Emperean Reanimate RELEASE_1

local CFrame = CFrame
local CFramenew = CFrame.new
local CFrameAngles = CFrame.Angles
local CFrameidentity = CFrame.identity

local Accessories = {
	{ Mesh = "14768666349", Texture = "14768664565", Name = "Torso" },
	{ Mesh = "14768684979", Texture = "14768683674", CFrame = CFrameAngles(0, 0, 1.57), Name = "Right Arm" },
	{ Mesh = "14768684979", Texture = "14768683674", CFrame = CFrameAngles(0, 0, 1.57), Name = "Left Arm" }
}

local Success = false
local Changed = nil
local CharacterAdded = nil
local Connection = nil

local Linear = 26
local Angular = 0
local Sleep = 0

local RaycastParameters = RaycastParams.new()
RaycastParameters.FilterType = Enum.RaycastFilterType.Exclude

local Aligns = { }
local Attachments = { }
local Blacklist = { }

local Instancenew = Instance.new

local osclock = os.clock

local stringmatch = string.match

local math = math
local mathabs = math.abs
local mathcos = math.cos
local mathclamp = math.clamp
local mathrandom = math.random

local table = table
local tableinsert = table.insert
local tableremove = table.remove
local tableclear = table.clear
local tablefind = table.find

local Vector3 = Vector3
local Vector3new = Vector3.new
local Vector3zero = Vector3.zero

local HeadSize = Vector3new(2, 1, 1)
local TorsoSize = Vector3new(2, 2, 1)
local LimbSize = Vector3new(1, 2, 1)
local Scale = Vector3new(1.25, 1.25, 1.25)
local RaycastDirection = Vector3new(0, - 1000, 0)

local MeshTypeHead = Enum.MeshType.Head

local task = task
local taskwait = task.wait
local taskspawn = task.spawn
local taskdefer = task.defer

local Workspace = game:FindFirstChildOfClass("Workspace")
local CurrentCamera = nil

local LocalPlayer = game:FindFirstChildOfClass("Players").LocalPlayer
local Name = LocalPlayer.Name
local Character = LocalPlayer.Character

local RunService = game:FindFirstChildOfClass("RunService")
local PreSimulation = RunService.PreSimulation
local PreRender = RunService.PreRender
local PostSimulation = RunService.PostSimulation

local StarterGui = game:FindFirstChildOfClass("StarterGui")

local function RefitCamera()
	CurrentCamera = Workspace.CurrentCamera

	if not CurrentCamera then
		Workspace:GetPropertyChangedSignal("CurrentCamera"):Wait()
		CurrentCamera = Workspace.CurrentCamera
	end

	Changed = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
		CurrentCamera = Workspace.CurrentCamera
	end)
end

local function Parented(Instance)
	return typeof(Instance) == "Instance" and Instance:IsDescendantOf(game)
end

local function FindInstance(Parent, ClassName, Name)
	if Parented(Parent) then
		for _, Instance in pairs(Parent:GetChildren()) do
			if Instance:IsA(ClassName) and Instance.Name == Name then
				return Instance
			end
		end
	end
end

local function WaitForChildOfClass(Parent, ClassName)
	if Parented(Parent) then
		local Instance = Parent:FindFirstChildOfClass(ClassName)

		while Parented(Parent) and not Instance do
			Parent.ChildAdded:Wait()
			Instance = Parent:FindFirstChildOfClass(ClassName)
		end

		return Instance
	end
end

local function WaitForChildOfClassAndName(Parent, ...)
	if Parented(Parent) then
		local Instance = FindInstance(Parent, ...)

		while Parented(Parent) and not Instance do
			Parent.ChildAdded:Wait()
			Instance = FindInstance(Parent, ...)
		end

		return Instance
	end
end

local function Part(Name, Size, Parent)
	local Part = Instancenew("Part")
	Part.Name = Name
	Part.Size = Size
	Part.Transparency = 1
	Part.Parent = Parent

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

local function Rig()
	local CharacterClone = Instancenew("Model")
	CharacterClone.Name = Name

	local Head = Part("Head", HeadSize, CharacterClone)
	local HumanoidRootPart = Part("HumanoidRootPart", TorsoSize, CharacterClone)
	local Torso = Part("Torso", TorsoSize, CharacterClone)
	local RightArm = Part("Right Arm", LimbSize, CharacterClone)
	local LeftArm = Part("Left Arm", LimbSize, CharacterClone)
	local RightLeg = Part("Right Leg", LimbSize, CharacterClone)
	local LeftLeg = Part("Left Leg", LimbSize, CharacterClone)

	Motor6D("Neck", Torso, Head, CFramenew(0, 1, 0) * CFrameAngles(-90, 180, 0), CFramenew(0, -0.5, 0) * CFrameAngles(-90, 180, 0))
	Motor6D("RootJoint", HumanoidRootPart, Torso, CFrameAngles(-90, 180, 0), CFrameAngles(-90, 180, 0))
	Motor6D("Right Shoulder", Torso, RightArm, CFramenew(1, 0.5, 0) * CFrameAngles(0, 90, 0), CFramenew(- 0.5, 0.5, 0) * CFrameAngles(0, 90, 0))
	Motor6D("Left Shoulder", Torso, LeftArm, CFramenew(- 1, 0.5, 0) * CFrameAngles(0, - 90, 0), CFramenew(0.5, 0.5, 0) * CFrameAngles(0, - 90, 0))
	Motor6D("Right Hip", Torso, RightLeg, CFramenew(1, -1, 0) * CFrameAngles(0, 90, 0), CFramenew(0.5, 1, 0) * CFrameAngles(0, 90, 0))
	Motor6D("Left Hip", Torso, LeftLeg, CFramenew(-1, -1, 0) * CFrameAngles(0, -90, 0), CFramenew(-0.5, 1, 0) * CFrameAngles(0, -90, 0))

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

	local BasePart = FindInstance(Character, "BasePart", "HumanoidRootPart") or FindInstance(Character, "BasePart", "Torso") or FindInstance(Character, "BasePart", "UpperTorso") or FindInstance(Character, "BasePart", "LowerTorso") or FindInstance(Character, "BasePart", "Head") or Character and Character:FindFirstChildOfClass("BasePart", true)
	HumanoidRootPart.CFrame = BasePart and BasePart.CFrame or CFrameidentity

	local Mesh = Instancenew("SpecialMesh")
	Mesh.Name = "Mesh"
	Mesh.MeshType = MeshTypeHead
	Mesh.Scale = Scale
	Mesh.Parent = Head

	local face = Instancenew("Decal")
	face.Name = "face"
	face.Parent = Head

	local Humanoid = Instancenew("Humanoid", CharacterClone)
	Instancenew("Animator", Humanoid)

	Instancenew("Shirt", CharacterClone)
	Instancenew("Pants", CharacterClone)

	Instancenew("BodyColors", CharacterClone)

	local Animate = Instancenew("LocalScript")
	Animate.Name = "Animate"
	Animate.Parent = CharacterClone

	CharacterClone.PrimaryPart = Head
	CharacterClone.Parent = Workspace

	return CharacterClone, Humanoid, HumanoidRootPart
end

local CharacterClone = nil
local Humanoid = nil
local HumanoidRootPart = nil

local CloneAccessories = { }

local function AlignAccessory(Handle, MeshId, TextureId, HandleClone)
	local AccessoryAlign = true

	for _, Table in pairs(Accessories) do
		if stringmatch(MeshId, Table.Mesh) and stringmatch(TextureId, Table.Texture) and not Parented(Table.Handle) then
			local Target = Table.Name
			if type(Target) == "string" then
				Target = FindInstance(CharacterClone, "BasePart", Table.Name)
			end
			if typeof(Target) == "Instance" then
				Table.Handle = Handle
				tableinsert(Aligns, { Part0 = Handle, Part1 = Target, CFrame = Table.CFrame })
				AccessoryAlign = false
				break
			end
		end
	end

	if AccessoryAlign then
		tableinsert(Aligns, { Part0 = Handle, Part1 = HandleClone })
	end
end

local function DescendantAdded(Instance)
	if Instance:IsA("Accessory") then
		taskspawn(function()
			local Handle = WaitForChildOfClassAndName(Instance, "BasePart", "Handle")
			local IsA = Handle:IsA("MeshPart")

			local Mesh = IsA and Handle or WaitForChildOfClass(Handle, "SpecialMesh")
			local MeshId = Mesh.MeshId

			local Id = IsA and "TextureID" or "TextureId"
			local TextureId = Mesh[Id]

			local Create = true
			
			for _, Table in pairs(CloneAccessories) do
				if Table.Mesh == MeshId and Table.Texture == TextureId and not Parented(Table.Handle) then
					Table.Handle = Handle
					Create = false

					AlignAccessory(Handle, MeshId, TextureId, Table.HandleClone)
					break
				end
			end

			if Create then
				Instance.Archivable = true

				for _, Instance in pairs(Instance:GetDescendants()) do
					Instance.Archivable = true
				end

				local AccessoryClone = Instance:Clone()
				AccessoryClone.Parent = CharacterClone

				local HandleClone = WaitForChildOfClassAndName(AccessoryClone, "BasePart", "Handle")
				HandleClone.Transparency = 1
				HandleClone:BreakJoints()

				local Attachment = WaitForChildOfClass(HandleClone, "Attachment")
				local Name = Attachment.Name

				local Weld = Instancenew("Weld")
				Weld.Name = "AccessoryWeld"
				Weld.Part0 = HandleClone
				Weld.C0 = Attachment.CFrame

				for _, Attachment in pairs(Attachments) do
					if Attachment.Name == Name then
						Weld.Part1 = Attachment.Parent
						Weld.C1 = Attachment.CFrame
					end
				end

				Weld.Parent = HandleClone

				AlignAccessory(Handle, MeshId, TextureId, HandleClone)
				tableinsert(CloneAccessories, { Mesh = Mesh.MeshId, Texture = Mesh[Id], HandleClone = HandleClone, Handle = Handle })
			end
		end)
	elseif Instance:IsA("JointInstance") then
		taskspawn(function()
			taskwait()
			Instance:Destroy()
		end)
	end
end

local function RefreshCamera()
	local CameraCFrame = CurrentCamera.CFrame

	taskspawn(function()
		CurrentCamera:GetPropertyChangedSignal("CFrame"):Wait()
		CurrentCamera.CFrame = CameraCFrame
	end)
end

local function CameraSubject()
	if CurrentCamera.CameraSubject ~= Humanoid then
		CurrentCamera.CameraSubject = Humanoid
	end
end

local function OnCharacterAdded()
	local Character = LocalPlayer.Character

	if Character ~= CharacterClone then
		for _, Table in pairs(Aligns) do
			Table.Handle = nil
		end

		RefreshCamera()
		CameraSubject()

		taskspawn(function()
			WaitForChildOfClass(Character, "Humanoid")
			PreSimulation:Wait()

			RefreshCamera()
			CameraSubject()
			LocalPlayer.Character = CharacterClone
		end)

		RaycastParameters.FilterDescendantsInstances = { Character }

		local Position = HumanoidRootPart.Position + Vector3new(mathrandom(- 32, 32), 1, mathrandom(- 32, 32))
		local RaycastResult = Workspace:Raycast(Position, RaycastDirection, RaycastParameters)
		WaitForChildOfClassAndName(Character, "BasePart", "HumanoidRootPart").CFrame = RaycastResult and CFramenew(RaycastResult.Position) or CFramenew(Position)

		PreSimulation:Wait()
		Character:BreakJoints()

		for _, Instance in pairs(Character:GetDescendants()) do
			DescendantAdded(Instance)
		end

		Character.DescendantAdded:Connect(DescendantAdded)
	end
end

local function Disconnect(Argument)
	if typeof(Argument) == "RBXScriptConnection" then
		Argument:Disconnect()
	end
end

local function StopReanimate()
	Disconnect(Changed)
	Disconnect(CharacterAdded)
	Disconnect(Connection)

	if Parented(CharacterClone) then
		CharacterClone:Destroy()
	end
end

local function Align(Part0, Part1, CFrame)
	if Parented(Part0) and Part0.ReceiveAge == 0 and Parented(Part1) then
		Part0.AssemblyAngularVelocity = Vector3zero

		local LinearVelocity = Part1.AssemblyLinearVelocity * Linear
		Part0.AssemblyLinearVelocity = Vector3new(LinearVelocity.X, Linear, LinearVelocity.Z)

		Part0.CFrame = Part1.CFrame * Sleep * ( CFrame or CFrameidentity )
	end
end

local function Reanimate()
	local clock = osclock()
	CharacterClone, Humanoid, HumanoidRootPart = Rig()

	CharacterClone:GetPropertyChangedSignal("Parent"):Connect(function()
		if not Parented(CharacterClone) then
			StopReanimate()
		end
	end)

	local BindableEvent = Instancenew("BindableEvent")

	local function SetCore()
		StarterGui:SetCore("ResetButtonCallback", BindableEvent)
	end

	BindableEvent.Event:Connect(StopReanimate)
	RefitCamera()

	OnCharacterAdded()
	CharacterAdded = LocalPlayer:GetPropertyChangedSignal("Character"):Connect(OnCharacterAdded)

	local Success = false

	Connection = PostSimulation:Connect(function()
		if not Success then
			Success = pcall(SetCore)
		else
			SetCore()
		end

		local clock = osclock()

		Linear = 28 + mathcos(clock)
		local Axis = 0.0075 * mathcos(clock * 15)
		Sleep = CFramenew(0, 0, Axis)

		for Index, Table in pairs(Aligns) do
			Align(Table.Part0, Table.Part1, Table.CFrame)
		end
	end)

	return {
		Version = "RELEASE_1",
		Time = osclock() - clock,
	}
end

local API = Reanimate()
print("Emperean Reanimate:", API.Version, API.Time)
