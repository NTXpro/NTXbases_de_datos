/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROC [ERP].[Usp_Sel_TrabajadorFamilia]
@IdEmpresa INT,
@IdTrabajador INT
AS
BEGIN
	  SELECT   TF.ID
		  ,TF.IdTrabajador
		  ,TF.IdEntidad
		  ,TF.IdVinculoFamiliar
		  ,TF.FechaDeAlta
		  ,TF.IdEstablecimiento
		  ,TF.IdEmpresa
		  ,P.Nombre
		  ,P.ApellidoPaterno
		  ,P.ApellidoMaterno
		  ,VF.Nombre NombreVinculoFamiliar
		  ,EST.Direccion
		  ,TD.ID IdTipoDocumento
		  ,TD.Abreviatura TipoDocumento
		  ,ETD.NumeroDocumento
		   ,TF.FlagBaja
		  ,MB.Nombre NombreMotivoBaja
		  ,TF.FechaBaja
  FROM ERP.TrabajadorFamilia TF
  INNER JOIN ERP.Entidad E ON E.ID = TF.IdEntidad
  INNER JOIN ERP.Persona P ON P.IdEntidad = E.ID
  INNER JOIN [PLAME].[T19VinculoFamiliar] VF ON VF.ID = TF.IdVinculoFamiliar
  INNER JOIN ERP.Establecimiento EST ON EST.ID = TF.IdEstablecimiento
  INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = E.ID
  INNER JOIN [PLE].[T2TipoDocumento] TD ON TD.ID = ETD.IdTipoDocumento
  LEFT JOIN [PLAME].[T20MotivoBaja] MB ON MB.ID = TF.IdMotivoBaja
  WHERE TF.IdEmpresa = @IdEmpresa AND TF.IdTrabajador = @IdTrabajador
END
