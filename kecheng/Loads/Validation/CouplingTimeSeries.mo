within ;
model CouplingTimeSeries
  "Example illustrating the coupling of a building model to heating water and chilled water loops"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Source side medium";
  //parameter Modelica.SIunits.Time perAve=600
    //"Period for time averaged variables";
  buildingseries bui(
    filNam="D:/Modelica_file/modelica-buildings/Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    facMulHea=10,
    facMulCoo=40,
    k=1,
    Ti=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=false,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    "Building"
    annotation (Placement(transformation(extent={{10,-4},{30,16}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{23,-23},{-23,23}},rotation=0,origin={119,31})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{22,-22},{-22,22}},rotation=0,origin={118,-28})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(
    y=bui.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(
    y=bui.T_aChiWat_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-40,50})));
  Buildings.Fluid.Sources.Boundary_pT supChiWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1)
    "Chilled water supply"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=0,origin={-40,-10})));
equation
  connect(supHeaWat.T_in,THeaWatSup.y)
    annotation (Line(points={{-64,58},{-80,58},{-80,40},{-99,40}},color={0,0,127}));
  connect(TChiWatSup.y,supChiWat.T_in)
    annotation (Line(points={{-99,-20},{-80,-20},{-80,-2},{-64,-2}},  color={0,0,127}));
  connect(supHeaWat.ports[1],bui.ports_aHeaWat[1])
    annotation (Line(points={{-20,50},{0,50},{0,4},{10,4}},color={0,127,255}));
  connect(supChiWat.ports[1],bui.ports_aChiWat[1])
    annotation (Line(points={{-20,-10},{0,-10},{0,0},{10,0}},color={0,127,255}));
  connect(bui.ports_bHeaWat[1],sinHeaWat.ports[1])
    annotation (Line(points={{30,4},{60,4},{60,31},{96,31}}, color={0,127,255}));
  connect(sinChiWat.ports[1],bui.ports_bChiWat[1])
    annotation (Line(points={{96,-28},{60,-28},{60,0},{30,0}}, color={0,127,255}));
end CouplingTimeSeries;
