within ;
model InitialBuildingwithETS
  extends Modelica.Icons.Example;
  import TypDisSys=Buildings.Experimental.DHC.Types.DistrictSystemType
    "District system type enumeration";
  package MediumW=Buildings.Media.Water
    "Water";
  package MediumS=Modelica.Media.Water.IdealSteam
    "Steam";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal=1E4
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal=-1E4
    "Nominal mass flow rate";
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS
                              buiHeaGen1(
    redeclare final package MediumSerHea_a = MediumS,
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    bui(final have_heaWat=true),
    ets(
      final typ=TypDisSys.HeatingGeneration1,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal))
    "Building and ETS component - Heating only (steam)"
    annotation (Placement(transformation(extent={{-150,220},{-130,240}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 souDisSup(
    redeclare final package Medium = MediumS,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-230,220},{-210,240}})));
  Buildings.Fluid.Sources.Boundary_pT
                            sinDisRet(redeclare final package Medium = MediumW,
      nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-230,180},{-210,200}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate
                                                  senDifEntFlo(
    redeclare final package Medium1 = MediumS,
    redeclare final package Medium2 = MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-190,206},{-170,226}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.BuildingWithETS
                              buiHeaGen2(
    redeclare final package MediumSerHea_a = MediumS,
    redeclare final package MediumSer = MediumW,
    redeclare final package MediumBui = MediumW,
    nPorts_heaWat=1,
    bui(final have_heaWat=true),
    ets(
      final typ=TypDisSys.HeatingGeneration1,
      final m_flow_nominal=m_flow_nominal,
      final have_heaWat=true,
      QHeaWat_flow_nominal=QHeaWat_flow_nominal))
    "Building and ETS component - Heating only (steam)"
    annotation (Placement(transformation(extent={{24,0},{44,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T
                                 souDisSup1(
    redeclare final package Medium = MediumS,
    m_flow=m_flow_nominal,
    nPorts=1)
    "Source for district supply"
    annotation (Placement(transformation(extent={{-56,0},{-36,20}})));
  Buildings.Fluid.Sources.Boundary_pT
                            sinDisRet1(redeclare final package Medium = MediumW,
      nPorts=1)
    "Sink for district return"
    annotation (Placement(transformation(extent={{-78,-62},{-38,-22}})));
  Buildings.Experimental.DHC.Networks.BaseClasses.DifferenceEnthalpyFlowRate
                                                  senDifEntFlo1(
    redeclare final package Medium1 = MediumS,
    redeclare final package Medium2 = MediumW,
    final m_flow_nominal=m_flow_nominal)
    "Change in enthalpy flow rate "
    annotation (Placement(transformation(extent={{-16,-14},{4,6}})));
equation
  connect(souDisSup.ports[1],senDifEntFlo.port_a1)
    annotation (Line(points={{-210,230},{-202,230},{-202,222},{-190,222}},color={0,127,255}));
  connect(senDifEntFlo.port_b2,sinDisRet.ports[1])
    annotation (Line(points={{-190,210},{-202,210},{-202,190},{-210,190}},color={0,127,255}));
  connect(senDifEntFlo.port_b1,buiHeaGen1. port_aSerHea) annotation (Line(
        points={{-170,222},{-160,222},{-160,226},{-150,226}}, color={0,127,255}));
  connect(senDifEntFlo.port_a2,buiHeaGen1. port_bSerHea) annotation (Line(
        points={{-170,210},{-110,210},{-110,226},{-130,226}}, color={0,127,255}));
  connect(souDisSup1.ports[1], senDifEntFlo1.port_a1) annotation (Line(points={{
          -36,10},{-28,10},{-28,2},{-16,2}}, color={0,127,255}));
  connect(senDifEntFlo1.port_b2, sinDisRet1.ports[1]) annotation (Line(points={{-16,-10},
          {-28,-10},{-28,-42},{-38,-42}},          color={0,127,255}));
  connect(senDifEntFlo1.port_b1, buiHeaGen2.port_aSerHea)
    annotation (Line(points={{4,2},{14,2},{14,6},{24,6}}, color={0,127,255}));
  connect(senDifEntFlo1.port_a2, buiHeaGen2.port_bSerHea) annotation (Line(
        points={{4,-10},{64,-10},{64,6},{44,6}}, color={0,127,255}));
  annotation (uses(Buildings(version="8.0.0")));
end InitialBuildingwithETS;
