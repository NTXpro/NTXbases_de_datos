CREATE PROC [ERP].[Usp_Sel_Chofer_By_ID] 
@IdChofer INT
AS
BEGIN
        SELECT
                CH.ID,
                CH.UsuarioActivo,
                CH.UsuarioElimino,
                CH.UsuarioModifico,
                CH.UsuarioRegistro,
                CH.FechaActivacion,
                CH.FechaEliminado,
                CH.FechaModificado,
                EN.FechaRegistro,
                CH.IdEntidad,
                P.Nombre,
                P.ApellidoPaterno,
                P.ApellidoMaterno,
                ETD.NumeroDocumento,
                ETD.IdTipoDocumento,
                TD.Abreviatura,
                EN.Nombre RazonSocial,
                CH.Licencia
        FROM ERP.Chofer CH
        INNER JOIN ERP.Entidad EN ON EN.ID = CH.IdEntidad
        INNER JOIN ERP.Persona P ON P.IdEntidad = EN.ID
        INNER JOIN ERP.EntidadTipoDocumento ETD ON ETD.IdEntidad = EN.ID
        INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = ETD.IdTipoDocumento
        WHERE CH.ID = @IdChofer

END