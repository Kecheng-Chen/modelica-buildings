within kecheng.Loads.Validation;
model SeriesConstantFlow3
  extends Modelica.Icons.Example;
  BuildingTimeSeriesWithchillerborefield bui
    annotation (Placement(transformation(extent={{-34,8},{30,56}})));
  package Medium = Buildings.Media.Water "Medium model";
  parameter Integer nBui = datDes.nBui;
  parameter Boolean allowFlowReversalSer = true
    "Set to true to allow flow reversal in the service lines"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal for in-building systems"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  inner parameter Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Data.DesignDataSeries
                                        datDes(nBui=1, mCon_flow_nominal=fill(
        bui.ets.hex.m2_flow_nominal, nBui))
    "Design data"
    annotation (Placement(transformation(extent={{-86,72},{-66,92}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupSet(k=bui.bui.T_aHeaWat_nominal,
      y(final unit="K", displayUnit="degC"))
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-278,52},{-258,72}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(k=bui.bui.T_aChiWat_nominal,
      y(final unit="K", displayUnit="degC"))
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-320,-14},{-300,6}})));
  Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.UnidirectionalSeries
                                dis(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,-52},{20,-32}})));
  Modelica.Blocks.Sources.Constant masFloMaiPum(k=datDes.mDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{138,-208},{158,-188}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare final package Medium =
        Medium, final nPorts=1)
    "Boundary pressure condition representing the expansion vessel"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={74,-114})));
  Buildings.Fluid.Sensors.TemperatureTwoPort
                                   TDisWatRet(redeclare final package Medium =
        Medium, final m_flow_nominal=datDes.mDis_flow_nominal)
    "District water return temperature"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={42,-94})));
  Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses.Pump_m_flow
                                                     pumDis(
    redeclare final package Medium = Medium,
    final m_flow_nominal=datDes.mDis_flow_nominal,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution pump"
    annotation (Placement(transformation(
      extent={{10,-10},{-10,10}},
      rotation=90,
      origin={30,-144})));
  BuildingTimeSeriesWithchillerborefield bui1
    annotation (Placement(transformation(extent={{-246,-104},{-182,-56}})));
  Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.UnidirectionalSeries
                                dis1(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,-10},{20,10}},
        rotation=90,
        origin={-106,-144})));
  BuildingTimeSeriesWithchillerborefield bui2
    annotation (Placement(transformation(extent={{-216,-410},{-152,-362}})));
  Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.UnidirectionalSeries
                                dis2(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,-10},{20,10}},
        rotation=90,
        origin={-102,-412})));
  BuildingTimeSeriesWithchillerborefield bui3
    annotation (Placement(transformation(extent={{118,-286},{182,-238}})));
  Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.UnidirectionalSeries
                                dis3(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,-10},{20,10}},
        rotation=270,
        origin={32,-282})));
  BuildingTimeSeriesWithchillerborefield bui4
    annotation (Placement(transformation(extent={{118,-418},{182,-370}})));
  Buildings.Experimental.DHC.Examples.Combined.Generation5.Unidirectional.Networks.UnidirectionalSeries
                                dis4(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    final mDis_flow_nominal=datDes.mDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lCon=datDes.lCon,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer)
    "Distribution network"
    annotation (Placement(transformation(extent={{-20,-10},{20,10}},
        rotation=270,
        origin={34,-420})));
equation
  connect(THeaWatSupSet.y, bui.THeaWatSupSet) annotation (Line(points={{-256,62},
          {-40,62},{-40,45.9636},{-34,45.9636}},
                                           color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{-298,-4},
          {-40,-4},{-40,37.2364},{-34,37.2364}},
                                         color={0,0,127}));
  connect(dis.ports_bCon[1], bui.port_aSerAmb)
    annotation (Line(points={{-12,-32},{-12,-16},{-28,-16},{-28,25.4545},{
          -28.6667,25.4545}},                     color={0,127,255}));
  connect(bui.port_bSerAmb, dis.ports_aCon[1])
    annotation (Line(points={{24.6667,25.4545},{24,25.4545},{24,-4},{12,-4},{12,
          -32}},                                       color={0,127,255}));
  connect(bou.ports[1], pumDis.port_a)
    annotation (Line(points={{64,-114},{30,-114},{30,-134}},
                                                           color={0,127,255}));
  connect(TDisWatRet.port_b, pumDis.port_a)
    annotation (Line(points={{42,-104},{42,-134},{30,-134}},
                                                 color={0,127,255}));
  connect(TDisWatRet.port_a, dis.port_bDisSup) annotation (Line(points={{42,-84},
          {32,-84},{32,-42},{20,-42}}, color={0,127,255}));
  connect(masFloMaiPum.y, pumDis.m_flow_in) annotation (Line(points={{159,-198},
          {-26,-198},{-26,-144},{18,-144}}, color={0,0,127}));
  connect(dis1.ports_bCon[1], bui1.port_aSerAmb) annotation (Line(points={{-116,
          -156},{-246,-156},{-246,-86.5455},{-240.667,-86.5455}}, color={0,127,
          255}));
  connect(bui1.port_bSerAmb, dis1.ports_aCon[1]) annotation (Line(points={{
          -187.333,-86.5455},{-153.666,-86.5455},{-153.666,-132},{-116,-132}},
        color={0,127,255}));
  connect(dis1.port_bDisSup, dis.port_aDisSup) annotation (Line(points={{-106,
          -124},{-106,-42},{-20,-42}}, color={0,0,127}));
  connect(THeaWatSupSet.y, bui1.THeaWatSupSet) annotation (Line(points={{-256,62},
          {-192,62},{-192,-66.0364},{-246,-66.0364}},     color={0,0,127}));
  connect(TChiWatSupSet.y, bui1.TChiWatSupSet) annotation (Line(points={{-298,-4},
          {-276,-4},{-276,-74.7636},{-246,-74.7636}},     color={0,0,127}));
  connect(THeaWatSupSet.y, bui2.THeaWatSupSet) annotation (Line(points={{-256,62},
          {-148,62},{-148,-372.036},{-216,-372.036}},     color={0,0,127}));
  connect(TChiWatSupSet.y, bui2.TChiWatSupSet) annotation (Line(points={{-298,-4},
          {-276,-4},{-276,-380.764},{-216,-380.764}},     color={0,0,127}));
  connect(bui2.port_bSerAmb, dis2.ports_aCon[1]) annotation (Line(points={{
          -157.333,-392.545},{-134.666,-392.545},{-134.666,-400},{-112,-400}},
        color={0,127,255}));
  connect(bui2.port_aSerAmb, dis2.ports_bCon[1]) annotation (Line(points={{
          -210.667,-392.545},{-211.334,-392.545},{-211.334,-424},{-112,-424}},
        color={0,127,255}));
  connect(THeaWatSupSet.y, bui3.THeaWatSupSet) annotation (Line(points={{-256,62},
          {116,62},{116,-248.036},{118,-248.036}},     color={0,0,127}));
  connect(TChiWatSupSet.y, bui3.TChiWatSupSet) annotation (Line(points={{-298,-4},
          {96,-4},{96,-256.764},{118,-256.764}},     color={0,0,127}));
  connect(bui3.port_aSerAmb, dis3.ports_bCon[1]) annotation (Line(points={{123.333,
          -268.545},{82.6665,-268.545},{82.6665,-270},{42,-270}},         color=
         {0,127,255}));
  connect(bui3.port_bSerAmb, dis3.ports_aCon[1]) annotation (Line(points={{176.667,
          -268.545},{177.334,-268.545},{177.334,-294},{42,-294}},         color=
         {0,127,255}));
  connect(dis3.port_aDisSup, pumDis.port_b) annotation (Line(points={{32,-262},
          {32,-154},{30,-154}}, color={0,127,255}));
  connect(THeaWatSupSet.y, bui4.THeaWatSupSet) annotation (Line(points={{-256,62},
          {118,62},{118,-380.036}},     color={0,0,127}));
  connect(TChiWatSupSet.y, bui4.TChiWatSupSet) annotation (Line(points={{-298,-4},
          {96,-4},{96,-388.764},{118,-388.764}},     color={0,0,127}));
  connect(dis4.ports_bCon[1], bui4.port_aSerAmb) annotation (Line(points={{44,-408},
          {84,-408},{84,-400.545},{123.333,-400.545}},       color={0,127,255}));
  connect(bui4.port_bSerAmb, dis4.ports_aCon[1]) annotation (Line(points={{176.667,
          -400.545},{176.334,-400.545},{176.334,-432},{44,-432}},         color=
         {0,127,255}));
  connect(dis2.port_aDisSup, dis4.port_bDisSup) annotation (Line(points={{-102,
          -432},{-102,-518},{34,-518},{34,-440}}, color={0,127,255}));
  connect(dis3.port_bDisSup, dis4.port_aDisSup) annotation (Line(points={{32,
          -302},{32,-400},{34,-400}}, color={0,127,255}));
  connect(dis1.port_aDisSup, dis2.port_bDisSup) annotation (Line(points={{-106,
          -164},{-104,-164},{-104,-392},{-102,-392}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SeriesConstantFlow3;
