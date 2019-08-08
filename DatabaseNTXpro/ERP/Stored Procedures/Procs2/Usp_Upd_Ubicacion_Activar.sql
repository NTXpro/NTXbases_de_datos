﻿CREATE PROC [ERP].[Usp_Upd_Ubicacion_Activar]
@IdUbicacion INT,
@UsuarioActivo VARCHAR(250),
@FechaActivacion DATETIME
AS
BEGIN
	UPDATE ERP.Ubicacion SET 
	Flag = 1,
	[UsuarioActivo] = @UsuarioActivo,
	[FechaActivacion] = @FechaActivacion
	WHERE ID = @IdUbicacion
END