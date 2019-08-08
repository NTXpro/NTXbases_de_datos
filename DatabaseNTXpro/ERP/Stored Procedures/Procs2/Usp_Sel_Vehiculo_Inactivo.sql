CREATE PROC [ERP].[Usp_Sel_Vehiculo_Inactivo]
AS
BEGIN

	SELECT VE.ID,
					   ENT.Nombre Chofer,
					   ENTR.Nombre Transporte,
					   TD.Nombre  TipoDocumento,
					   VE.IdChofer,
					   VE.IdEmpresaTransporte,
					   VE.IdTipoDocumento,
					   VE.Color,
					   VE.Marca,
					   VE.Placa,
					   VE.Modelo,
					   VE.Inscripcion,
					   VE.Flag,
					   VE.FlagBorrador,
					   VE.UsuarioRegistro,
					   VE.UsuarioModifico,
					   VE.UsuarioActivo,
					   VE.UsuarioElimino,
					   VE.FechaRegistro,
					   VE.FechaModificado,
					   VE.FechaEliminado,
					   VE.FechaActivacion
				FROM ERP.Vehiculo VE
				LEFT JOIN ERP.Chofer CH ON CH.ID = VE.IdChofer
				LEFT JOIN ERP.Entidad ENT ON ENT.ID = CH.IdEntidad
				LEFT JOIN ERP.Transporte TR ON TR.ID = VE.IdEmpresaTransporte
				LEFT JOIN ERP.Entidad ENTR ON ENTR.ID = TR.IdEntidad
				INNER JOIN PLE.T2TipoDocumento TD ON TD.ID = VE.IdTipoDocumento
				WHERE VE.Flag = 0 AND VE.FlagBorrador = 0

END