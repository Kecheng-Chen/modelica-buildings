within ;
partial model PartialBuildingwithChillerBorefield
  "Partial model of a building with ChillerBorefield"
  extends Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuildingWithPartialETS(
    nPorts_heaWat=1,
    nPorts_chiWat=1,
    redeclare
      Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield ets);
      //parameters of ets need to be defined

  // IO CONNECTORS
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC")
    "Chilled water supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,50})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupMaxSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point - Maximum value"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,120}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,70})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupMinSet(
    final unit="K",
    displayUnit="degC")
    "Heating water supply temperature set point - Minimum value"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-240,160}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,90})));
  // COMPONENTS
  Buildings.Controls.OBC.CDL.Continuous.Line resTHeaWatSup "HW supply temperature reset"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(k=0) "Zero"
    annotation (Placement(transformation(extent={{-180,-30},{-160,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "One"
    annotation (Placement(transformation(extent={{-180,-70},{-160,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mulPPumETS(u(final unit="W"), final k=facMul) if
                       have_pum "Scaling"
    annotation (Placement(transformation(extent={{190,50},{210,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPumETS(final unit="W") if
                       have_pum "ETS pump power" annotation (Placement(
        transformation(extent={{220,40},{260,80}}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={90,120})));

equation
  connect(TChiWatSupSet, ets.TChiWatSupSet) annotation (Line(points={{-240,80},{
          -52,80},{-52,-66},{-34,-66}},  color={0,0,127}));
  connect(resTHeaWatSup.y, ets.THeaWatSupSet) annotation (Line(points={{-88,-40},
          {-60,-40},{-60,-60},{-34,-60}}, color={0,0,127}));
  connect(THeaWatSupMaxSet, resTHeaWatSup.f2) annotation (Line(points={{-240,120},
          {-130,120},{-130,-48},{-112,-48}}, color={0,0,127}));
  connect(THeaWatSupMinSet, resTHeaWatSup.f1) annotation (Line(points={{-240,160},
          {-120,160},{-120,-36},{-112,-36}}, color={0,0,127}));
  connect(one.y, resTHeaWatSup.x2) annotation (Line(points={{-158,-60},{-126,-60},
          {-126,-44},{-112,-44}}, color={0,0,127}));
  connect(zer.y, resTHeaWatSup.x1) annotation (Line(points={{-158,-20},{-116,-20},
          {-116,-32},{-112,-32}}, color={0,0,127}));
  connect(mulPPumETS.y, PPumETS)
    annotation (Line(points={{212,60},{240,60}}, color={0,0,127}));
  connect(ets.PPum, mulPPumETS.u) annotation (Line(points={{34,-60},{180,-60},{
          180,60},{188,60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
              uses(Buildings(version="7.0.0")));
end PartialBuildingwithChillerBorefield;
