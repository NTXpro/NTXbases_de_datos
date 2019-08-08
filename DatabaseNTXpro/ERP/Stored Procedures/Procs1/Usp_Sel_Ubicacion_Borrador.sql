CREATE PROC [ERP].[Usp_Sel_Ubicacion_Borrador]
@IdEntidad INT
AS
BEGIN
	SELECT
    U.ID,
    U.Codigo,
    U.Nombre,
	U.FechaRegistro,
	A.Nombre AS NombreAlmacen
    FROM ERP.Ubicacion U
	LEFT JOIN ERP.Almacen A ON U.IdAlmacen = A.ID
    WHERE
    U.Flag = 1 AND
	U.FlagBorrador = 1 AND
	A.ID IN (SELECT DISTINCT A.ID  from ERP.Almacen A
			 LEFT JOIN ERP.Establecimiento E ON A.IdEstablecimiento = E.ID
			 WHERE E.IdEntidad = @IdEntidad)
END