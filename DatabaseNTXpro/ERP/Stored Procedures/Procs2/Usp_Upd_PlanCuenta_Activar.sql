﻿CREATE PROC [ERP].[Usp_Upd_PlanCuenta_Activar]
@IdPlanCuenta		INT,
@UsuarioActivo		VARCHAR(250)
AS
BEGIN
	UPDATE [ERP].[PlanCuenta] SET Flag = 1, FechaActivacion = DATEADD(HOUR, 3, GETDATE()),UsuarioActivo=@UsuarioActivo WHERE ID = @IdPlanCuenta
END
