CREATE PROC [ERP].[Usp_Ins_Asiento_Cierre]
@IdEmpresa INT,
@IdEntidad INT,
@IdAnio INT,
@ValorMesHasta INT, /*VALOR MES HASTA DONDE SE GENERA EL ASIENTO*/
@ValorMes INT, /*VALOR MES HASTA CON CUAL SE REGISTRARA EL ASIENTO*/
@IdOrigen INT,
@Fecha DATETIME, /*FECHA DE TIPO DE CAMBIO*/
@TipoCambio decimal(14,5),
@IdMoneda INT, /*SOLES POR DEFECTO -> EL ENVIO ES DESDE LA APLICACIÓN*/
@UsuarioRegistro varchar(250),
@FechaRegistro datetime
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	DECLARE @NOMBRE_ORIGEN VARCHAR(200) = (SELECT Nombre FROM Maestro.Origen WHERE ID = @IdOrigen);
	DECLARE @NOMBRE_ANIO VARCHAR(200) = (SELECT Nombre FROM Maestro.Anio WHERE ID = @IdAnio);
	DECLARE @ID_MES INT = (SELECT ID FROM Maestro.Mes WHERE Valor = @ValorMes);
	DECLARE @ID_PERIODO INT = (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio AND IdMes = @ID_MES);

	DECLARE @ORDEN_GENERADA INT;
	DECLARE @ORDEN_EXISTENTE INT = (SELECT COUNT(1) FROM ERP.Asiento WHERE IdPeriodo = @ID_PERIODO AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa)
	IF(@ORDEN_EXISTENTE > 0)
	BEGIN
		SET @ORDEN_GENERADA = (SELECT MAX(ISNULL(Orden, 0)) + 1 FROM ERP.Asiento WHERE IdPeriodo = @ID_PERIODO AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa);
	END
	ELSE
	BEGIN
		SET @ORDEN_GENERADA = 1;
	END
	
	DECLARE @ID_ASIENTO_ELIMINAR INT = (SELECT ID FROM ERP.Asiento WHERE IdPeriodo IN (SELECT ID FROM ERP.Periodo WHERE IdAnio = @IdAnio) AND IdOrigen = @IdOrigen AND IdEmpresa = @IdEmpresa);
	DELETE FROM ERP.AsientoDetalle WHERE IdAsiento = @ID_ASIENTO_ELIMINAR;
	DELETE FROM ERP.Asiento WHERE ID = @ID_ASIENTO_ELIMINAR;

	DECLARE @ID_ASIENTO INT;
	INSERT INTO [ERP].[Asiento]
           ([Nombre]
           ,[Orden]
           ,[Fecha]
           ,[IdEmpresa]
           ,[IdPeriodo]
           ,[IdOrigen]
           ,[IdMoneda]
           ,[TipoCambio]
           ,[UsuarioRegistro]
           ,[FechaRegistro]
		   ,UsuarioModifico,
		   FechaModificado
           ,[FlagEditar]
           ,[FlagBorrador]
           ,[Flag])
     VALUES
           (@NOMBRE_ORIGEN + ' DEL AÑO ' + @NOMBRE_ANIO,
            @ORDEN_GENERADA,
            @Fecha,
			@IdEmpresa,
			@ID_PERIODO,
			@IdOrigen,
            @IdMoneda,
            @TipoCambio,
            @UsuarioRegistro,
            @FechaRegistro,
			@UsuarioRegistro,
            @FechaRegistro,
            1,
            0,
            1)
	SET @ID_ASIENTO = CAST(SCOPE_IDENTITY() AS int)

	INSERT INTO [ERP].[AsientoDetalle] (
		IdAsiento,
		Orden,
		IdPlanCuenta,
		Nombre,
		IdEntidad,
		ImporteSoles,
		IdDebeHaber)	
	SELECT 
		@ID_ASIENTO,
		ROW_NUMBER() OVER(ORDER BY TEMP.CuentaContable) Orden,
		TEMP.IdPlanCuenta,
		TEMP.NombrePlanCuenta,
		--TEMP.IdEntidad,
		NULL,
		(CASE 
			WHEN TEMP.DEBE = TEMP.HABER THEN 0
			WHEN TEMP.DEBE > TEMP.HABER THEN (TEMP.DEBE - TEMP.HABER) 
			WHEN TEMP.DEBE < TEMP.HABER THEN (TEMP.HABER - TEMP.DEBE)  
		END) AS ImporteSoles,
		(CASE 
			WHEN TEMP.DEBE = TEMP.HABER THEN NULL /*SIN IDENTIFICADOR*/
			WHEN TEMP.DEBE > TEMP.HABER THEN 2 /*IDENTIFICADOR DE HABER*/
			WHEN TEMP.DEBE < TEMP.HABER THEN 1 /*IDENTIFICADOR DE HABER*/
		END) AS IdDebeHaber
	FROM
	(SELECT 
		PC.ID AS IdPlanCuenta,
		PC.Nombre AS NombrePlanCuenta,
		PC.CuentaContable AS CuentaContable,
		/*AD.IdEntidad,*/
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) AS DEBE,
		ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) AS HABER
	FROM
	ERP.AsientoDetalle AD
	INNER JOIN ERP.PlanCuenta PC ON AD.IdPlanCuenta = PC.ID
	INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
	INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
	INNER JOIN Maestro.Anio AN ON P.IdAnio = AN.ID
	INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
	INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
	WHERE
	P.IdAnio = @IdAnio AND
	M.Valor BETWEEN 0 AND @ValorMesHasta AND
	A.IdEmpresa = @IdEmpresa AND
	A.FlagBorrador = 0 AND
	A.Flag = 1 AND
	A.ID NOT IN (SELECT 
				 A.ID AS ID
				 FROM ERP.AsientoDetalle AD
				 INNER JOIN ERP.Asiento A ON AD.IdAsiento = A.ID
				 INNER JOIN ERP.Periodo P ON A.IdPeriodo = P.ID
				 INNER JOIN Maestro.Mes M ON P.IdMes = M.ID
				 INNER JOIN Maestro.Origen O ON A.IdOrigen = O.ID
				 WHERE 
				 A.IdEmpresa = @IdEmpresa AND
				 P.IdAnio = @IdAnio AND
				 M.Valor BETWEEN 0 AND @ValorMesHasta
				 GROUP BY A.ID
				 HAVING
				 ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) <>
				 ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0)
				 UNION
				 SELECT DISTINCT IdAsiento AS ID FROM ERP.AsientoDetalle WHERE IdPlanCuenta IS NULL)
	GROUP BY PC.ID, PC.Nombre, PC.CuentaContable
	HAVING
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 1 THEN AD.ImporteSoles END), 0) -
	ISNULL(SUM(CASE AD.IdDebeHaber WHEN 2 THEN AD.ImporteSoles END), 0) <> 0) AS TEMP

	SELECT @ID_ASIENTO
END