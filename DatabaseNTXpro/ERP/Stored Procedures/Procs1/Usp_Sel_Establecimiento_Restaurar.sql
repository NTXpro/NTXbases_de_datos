CREATE PROC [ERP].[Usp_Sel_Establecimiento_Restaurar]
@IdEntidad INT
AS
BEGIN
	SELECT
    E.ID,
    E.Nombre,
    E.Direccion
    FROM ERP.Establecimiento E
    WHERE E.IdEntidad = @IdEntidad AND
    Flag = 0
END
