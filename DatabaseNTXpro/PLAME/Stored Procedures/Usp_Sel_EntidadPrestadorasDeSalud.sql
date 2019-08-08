/****** Script for SelectTopNRows command from SSMS  ******/
CREATE PROC PLAME.Usp_Sel_EntidadPrestadorasDeSalud
AS
BEGIN
SELECT EPS.ID
      ,EPS.IdEntidad
      ,EPS.CodigoSunat
	  ,E.Nombre NombreEntidad
  FROM PLAME.T14EntidadPrestadorasDeSalud EPS
  INNER JOIN ERP.Entidad E ON E.ID = EPS.IdEntidad
  WHERE EPS.Flag = 1 AND EPS.FlagBorrador = 0
  END
