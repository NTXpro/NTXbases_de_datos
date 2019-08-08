﻿
CREATE FUNCTION [Maestro].[ObtenerIdEstadoContribuyente_By_Nombre](
@Nombre VARCHAR(50)
)
RETURNS INT
AS
BEGIN

DECLARE @Id VARCHAR(6)= (SELECT ID FROM Maestro.EstadoContribuyente WHERE Nombre = @Nombre)

RETURN ISNULL(@Id,0)
END
