﻿CREATE PROC ERP.Usp_Sel_PropiedadBorrador
AS
BEGIN

		SELECT PRO.ID,
			   PRO.Nombre,
			   UM.Nombre		AS	UnidadMedida,
			   UM.CodigoSunat,
			   PRO.FechaRegistro,
			   PRO.FechaEliminado,
			   PRO.FechaModificado,
			   PRO.FechaActivacion,
			   PRO.UsuarioRegistro,
			   PRO.UsuarioModifico,
			   PRO.UsuarioElimino,
			   PRO.UsuarioActivo
		FROM Maestro.Propiedad PRO
		LEFT JOIN PLE.T6UnidadMedida UM
		ON UM.ID = PRO.IdUnidadMedida
		WHERE PRO.FlagBorrador = 1 AND PRO.Flag = 1 

END
