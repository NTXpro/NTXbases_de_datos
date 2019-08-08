CREATE proc ERP.Usp_Sel_Parametro_By_TipoParametro --1
@IdTipoParametro INT
AS
BEGIN
	
	SELECT DISTINCT ID,
					NOMBRE,
					ABREVIATURA 
	FROM ERP.Parametro
	WHERE IdTipoParametro = 2
	

END