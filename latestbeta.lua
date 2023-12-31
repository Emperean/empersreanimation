-- BETA_Empereanimate_5 ( BE5 )
-- Reworked hat refresh system
-- template coming soon <3
-- WE ARE SO CLOSE TO FULL RELEASE!

if not game:IsLoaded() then
	game.Loaded:Wait()
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

local Fling = { }
local Aligns = { }
local Blacklist = { }
local Accessories = { }
local Attachments = { }

local Instancenew = Instance.new

local taskwait = task.wait
local taskspawn = task.spawn
local taskdefer = task.defer

local mathabs = math.abs
local mathcos = math.cos
local mathrandom = math.random

local stringmatch = string.match

local osclock = os.clock

local tableinsert = table.insert
local tableclear = table.clear
local tablefind = table.find

local CFramenew = CFrame.new
local CFrameAngles = CFrame.Angles
local CFrameidentity = CFrame.identity

local Vector3new = Vector3.new
local Vector3zero = Vector3.zero

local Sleep = CFrameidentity
local Velocity = Vector3new(16384, 16384, 16384)
local Angular = 0
local Linear = 0

local Workspace = game:FindFirstChildOfClass("Workspace")
local CurrentCamera = Workspace.CurrentCamera

local Players = game:FindFirstChildOfClass("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local RunService = game:FindFirstChildOfClass("RunService")
local PreSimulation = RunService.PreSimulation
local PostSimulation = RunService.PostSimulation

local Character = LocalPlayer.Character
local CharacterClone = Instancenew("Model")

local StarterGui = game:FindFirstChildOfClass("StarterGui")
local BindableEvent = Instancenew("BindableEvent")

local UserInputService = game:FindFirstChildOfClass("UserInputService")
local UserInputType = Enum.UserInputType

local MouseButton1 = UserInputType.MouseButton1
local Touch = UserInputType.Touch

local InputBegan = UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	local Type = Input.UserInputType

	if not GameProcessed and ( Type == MouseButton1 or Type == Touch ) then
		local Target = Mouse.Target

		if Target and not Target.Anchored and not Target:IsDescendantOf(CharacterClone) and not Target:IsDescendantOf(Character) and not tablefind(Fling, Target) then
			local Parent = Target.Parent

			if Parent:IsA("Model") and Parent ~= Character and Parent:FindFirstChildOfClass("Humanoid") then
				local HumanoidRootPart = FindInstance(Parent, "BasePart", "HumanoidRootPart") or FindInstance(Parent, "BasePart", "Torso") or FindInstance(Parent, "BasePart", "Head")

				if HumanoidRootPart and not tablefind(Fling, HumanoidRootPart) then
					tableinsert(Fling, HumanoidRootPart)
					return
				end
			end

			tableinsert(Fling, Target)
		end
	end
end)

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

for _, Table in pairs(AccessoryTable) do
	if type(Table.Mesh) ~= "string" then
		Table.Mesh = ""
	end
	if type(Table.Texture) ~= "string" then
		Table.Texture = ""
	end
end

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

Instancenew("LocalScript", CharacterClone).Name = "Animate"

CharacterClone.PrimaryPart = Head
CharacterClone.Parent = Workspace

local function DescendantAdded(Instance)
	if Instance:IsA("Accessory") then
		taskspawn(function()
			local Handle = WaitForClassOfName(Instance, "BasePart", "Handle")
			local MeshPart = Handle:IsA("MeshPart")
			local Id = MeshPart and "TextureID" or "TextureId"
			
			local Mesh = MeshPart and Handle or WaitForClass(Handle, "SpecialMesh")
			
			local Create = true
			
			for _, Table in pairs(Accessories) do
				local TableMesh = Table.Mesh
				
				if TableMesh[Id] == Mesh[Id] and TableMesh.MeshId == Mesh.MeshId then
					local TableHandle = Table.Handle

					if TableHandle then
						for _, Table in pairs(AccessoryTable) do
							local Instance = Table.Instance

							if Instance then
								if stringmatch(Mesh.MeshId, Table.Mesh) and stringmatch(Mesh[Id], Table.Texture) and not tablefind(Blacklist, Instance) then
									tableinsert(Blacklist, Instance)
									tableinsert(Aligns, { Handle, Instance, Table.CFrame or CFrameidentity })
									return
								end
							end
						end

						tableinsert(Aligns, { Handle, TableHandle, CFrameidentity })
					end
					
					Create = false
				end
			end
			
			if Create then
				Instance.Archivable = true
				
				for _, Instance in pairs(Instance:GetDescendants()) do
					Instance.Archivable = true
				end
				
				local AccessoryClone = Instance:Clone()
				
				local HandleClone = FindInstance(AccessoryClone, "BasePart", "Handle")
				HandleClone.Transparency = 1
				HandleClone:BreakJoints()
					
				local MeshClone = MeshPart and HandleClone or WaitForClass(HandleClone, "SpecialMesh")
				local Attachment = WaitForClass(HandleClone, "Attachment")
				
				local Weld = Instancenew("Weld")
				Weld.Name = "AccessoryWeld"
				Weld.Part0 = HandleClone
				Weld.C0 = Attachment.CFrame
				
				local Name = Attachment.Name
				
				for _, TableAttachment in pairs(Attachments) do
					if TableAttachment.Name == Name then
						Weld.Part1 = TableAttachment.Parent
						Weld.C1 = TableAttachment.CFrame
					end
				end
				
				Weld.Parent = HandleClone
				AccessoryClone.Parent = CharacterClone
				
				for _, Table in pairs(AccessoryTable) do
					local Instance = Table.Instance

					if Instance then
						if stringmatch(Mesh.MeshId, Table.Mesh) and stringmatch(Mesh[Id], Table.Texture) and not tablefind(Blacklist, Instance) then
							tableinsert(Blacklist, Instance)
							tableinsert(Aligns, { Handle, Instance, Table.CFrame or CFrameidentity })
							return
						end
					end
				end
				
				tableinsert(Aligns, { Handle, HandleClone, CFrameidentity })
				tableinsert(Accessories, { Handle = HandleClone, Mesh = MeshClone })
			end
		end)
	elseif Instance:IsA("JointInstance") then
		taskspawn(function()
			taskwait()
			Instance:Destroy()
		end)
	end
end

local function CharacterAdded(Character)
	if Character ~= CharacterClone then		
		PostSimulation:Wait()

		local Backpack = LocalPlayer:FindFirstChildOfClass("Backpack")

		if Backpack then
			Backpack:ClearAllChildren()
		end

		tableclear(Aligns)
		tableclear(Blacklist)

		local CurrentCameraCFrame = CurrentCamera.CFrame

		LocalPlayer.Character = CharacterClone
		CurrentCamera.CameraSubject = Humanoid

		taskspawn(function()
			CurrentCamera:GetPropertyChangedSignal("CFrame"):Wait()
			CurrentCamera.CFrame = CurrentCameraCFrame
		end)
		
		taskspawn(function()
			while Character do
				for _, BasePart in pairs(Character:GetDescendants()) do
					if BasePart:IsA("BasePart") then
						BasePart.CanCollide = false
					end
				end				
				
				PreSimulation:Wait()
			end
		end)
		
		local CharacterHumanoidRootPart = WaitForClassOfName(Character, "BasePart", "HumanoidRootPart")

		for Index, Value in pairs(Fling) do
			local BasePart = nil

			if typeof(Value) == "Instance" then 
				if Value:IsA("BasePart") then
					BasePart = Value
				elseif Value:IsA("Humanoid") then
					local Model = Value.Parent

					if Model ~= Character and Model:IsA("Model") then
						BasePart = FindInstance(Model, "BasePart", "HumanoidRootPart") or FindInstance(Model, "BasePart", "Head") or Model:FindFirstChildOfClass("BasePart")
					end
				elseif Value:IsA("Model") and Value ~= Character then
					BasePart = FindInstance(Value, "BasePart", "HumanoidRootPart") or FindInstance(Value, "BasePart", "Head") or Value:FindFirstChildOfClass("BasePart")
				end
			end

			if BasePart then
				local clock = osclock()

				while CharacterHumanoidRootPart and BasePart and osclock() - clock <= 1 and BasePart.AssemblyLinearVelocity.Magnitude <= 60 do
					CharacterHumanoidRootPart.AssemblyAngularVelocity = Velocity
					CharacterHumanoidRootPart.AssemblyLinearVelocity = Velocity

					CharacterHumanoidRootPart.CFrame = BasePart.CFrame + Vector3new(0, - 1, 0)
					PostSimulation:Wait()
				end
			end
		end

		tableclear(Fling)

		if CharacterHumanoidRootPart then
			CharacterHumanoidRootPart.AssemblyAngularVelocity = Vector3zero
			CharacterHumanoidRootPart.AssemblyLinearVelocity = Vector3zero

			CharacterHumanoidRootPart.CFrame = CFramenew(HumanoidRootPart.Position + Vector3new(mathrandom(- 32, 32), 0, mathrandom(- 32, 32)))
			PostSimulation:Wait()
		end

		Character:BreakJoints()

		for _, Instance in pairs(Character:GetDescendants()) do
			DescendantAdded(Instance)
		end

		Character.DescendantAdded:Connect(DescendantAdded)
	end
end

local function Align(Part0, Part1, CFrame)
	if Part0.ReceiveAge == 0 and not Part0.Anchored and # Part0:GetJoints() == 0 then
		Part0.AssemblyAngularVelocity = Vector3new(0, Angular, 0)

		local Part1CFrame = Part1.CFrame
		local LinearVelocity = Part1.AssemblyLinearVelocity * Linear
		local Magnitude = LinearVelocity.Magnitude < Linear

		if Magnitude then
			local LookVector = Part1CFrame.LookVector * Linear
			Part0.AssemblyLinearVelocity = Vector3new(LookVector.X, Linear, LookVector.Z)
		else
			Part0.AssemblyLinearVelocity = Vector3new(LinearVelocity.X, Linear, LinearVelocity.Z)
		end

		Part0.CFrame = Part1CFrame * ( Magnitude and Sleep or CFrameidentity ) * CFrame
	end
end

if Character then
	CharacterAdded(Character)
end

local Added = LocalPlayer.CharacterAdded:Connect(CharacterAdded)

local Connection = game:FindFirstChildOfClass("RunService").PostSimulation:Connect(function()
	local osclock = osclock()
	local Axis = 0.004 * mathcos(osclock * 17.5)

	Sleep = CFramenew(0, Axis, 0)
	Angular = mathcos(osclock)
	Linear = 26

	for _, Table in pairs(Aligns) do
		Align(Table[1], Table[2], Table[3])
	end

	if sethiddenproperty then
		sethiddenproperty(LocalPlayer, "SimulationRadius", 10000000)
	end

	StarterGui:SetCore("ResetButtonCallback", BindableEvent) -- This is if it gets overriden, just like in MyWorld testing place.
end)

local function Event()
	CharacterClone:Destroy()
end

BindableEvent.Event:Connect(Event)

CharacterClone:GetPropertyChangedSignal("Parent"):Connect(function()
	if not CharacterClone.Parent then
		Added:Disconnect()
		Connection:Disconnect()

		CharacterClone:Destroy()

		if BindableEvent then
			BindableEvent:Destroy()
		end

		StarterGui:SetCore("ResetButtonCallback", true)
	end
end)

BindableEvent:GetPropertyChangedSignal("Parent"):Connect(Event)
