within ;
model Buildingtonet
  extends Partialbuildingtonet(
  redeclare BuildingTimeSerieswithChillerBorefield bui[nBui](
      final filNam=filNam));
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  annotation (experiment(
      StopTime=3600,
      __Dymola_NumberOfIntervals=600,
      __Dymola_Algorithm="Dassl"));
end Buildingtonet;
