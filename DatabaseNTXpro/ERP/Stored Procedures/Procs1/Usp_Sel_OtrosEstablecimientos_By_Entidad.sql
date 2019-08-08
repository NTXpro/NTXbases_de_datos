
create PROC [ERP].[Usp_Sel_OtrosEstablecimientos_By_Entidad]
@IdEntidad INT,
@Flag bit
AS
BEGIN

	SELECT	ID,
			IdEntidad,
			Nombre,
			Direccion 
	FROM 
	ERP.Establecimiento E
	WHERE IdEntidad = @IdEntidad AND E.IdTipoEstablecimiento != 1 AND Flag = @Flag
	

END
