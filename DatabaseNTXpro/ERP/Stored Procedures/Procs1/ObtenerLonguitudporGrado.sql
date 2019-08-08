CREATE PROC ERP.ObtenerLonguitudporGrado
@IdTipoGrado INT
AS
BEGIN

		SELECT Longitud 
		FROM Maestro.Grado
		WHERE ID = @IdTipoGrado
END
