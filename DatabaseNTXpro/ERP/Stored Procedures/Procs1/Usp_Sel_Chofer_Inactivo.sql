﻿CREATE PROC [ERP].[Usp_Sel_Chofer_Inactivo]
@IdEmpresa INT
AS
BEGIN

        SELECT  CH.ID,
                EN.Nombre,
                Ch.Licencia,
                CH.FechaRegistro,
                CH.FechaEliminado,
                ETD.NumeroDocumento,
                TD.Nombre AS NombreTipoDocumento
        FROM ERP.Chofer CH
        INNER JOIN ERP.Entidad EN
            ON EN.ID = CH.IdEntidad
        INNER JOIN ERP.EntidadTipoDocumento ETD
            ON ETD.IdEntidad = EN.ID
        INNER JOIN PLE.T2TipoDocumento TD
            ON TD.ID = ETD.IdTipoDocumento
        WHERE CH.FlagBorrador = 0 AND CH.IdEmpresa = @IdEmpresa AND CH.Flag = 0
END