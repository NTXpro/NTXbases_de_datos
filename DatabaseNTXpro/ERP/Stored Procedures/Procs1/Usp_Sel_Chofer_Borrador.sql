CREATE PROC [ERP].[Usp_Sel_Chofer_Borrador]
@IdEmpresa INT
AS
BEGIN

    SELECT  CH.ID,
        EN.Nombre,
        CH.Licencia,
        CH.FechaRegistro,
        CH.FechaEliminado,
        ETD.NumeroDocumento,
        TD.Nombre AS NombreTipoDocumento
    FROM ERP.Chofer CH
    INNER JOIN ERP.Entidad EN
      ON EN.ID = CH.IdEntidad
    LEFT JOIN ERP.EntidadTipoDocumento ETD
      ON ETD.IdEntidad = EN.ID
    LEFT JOIN PLE.T2TipoDocumento TD
      ON TD.ID = ETD.IdTipoDocumento
    WHERE CH.FlagBorrador = 1 AND CH.IdEmpresa = @IdEmpresa
END