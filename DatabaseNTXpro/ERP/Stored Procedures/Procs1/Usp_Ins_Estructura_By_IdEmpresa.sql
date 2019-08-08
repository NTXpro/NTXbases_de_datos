
CREATE PROC [ERP].[Usp_Ins_Estructura_By_IdEmpresa]
@IdEmpresaPlantilla INT,
@IdEmpresa INT
AS
BEGIN

	BEGIN -- DECLARACIÓN DE TABLA TEMPORAL

		DECLARE @Data TABLE(
			ID INT IDENTITY PRIMARY KEY,
			IdEstructuraUno INT,
			IdEmpresa INT,
			Tipo INT,
			Nombre VARCHAR(500),
			IdEstructuraDos INT,
			NombreEstructuraDos VARCHAR(500),
			IdEstructuraTres INT,
			NombreEstructuraTres VARCHAR(500),
			Orden INT,
			IdEstructuraCuatro INT,
			CuentaContable VARCHAR(100),
			Operador INT,
			IdUno INT,
			IdDos INT,
			IdTres INT,
			Flag BIT
		);

	END

	BEGIN -- INSERTAR DATOS EN TABLA TEMPORAL
		
		INSERT INTO @Data
		SELECT
			U.ID AS IdEstructuraUno,
			U.IdEmpresa,
			U.Tipo,
			U.Nombre AS NombreEstructuraUno,
			--------------------------------
			D.ID AS IdEstructuraDos,
			D.Nombre AS NombreEstructuraDos,
			--------------------------------
			T.ID AS IdEstructuraTres,
			T.Nombre AS NombreEstructuraTres,
			T.Orden AS Orden,
			--------------------------------
			C.ID AS IdEstructuraCuatro,
			C.CuentaContable,
			C.Operador,
			0,
			0,
			0,
			C.Flag
		FROM
		ERP.EstructuraUno U
		INNER JOIN ERP.EstructuraDos D ON U.ID = D.IdEstructuraUno
		INNER JOIN ERP.EstructuraTres T ON D.ID = T.IdEstructuraDos
		LEFT JOIN ERP.EstructuraCuatro C ON T.ID = C.IdEstructuraTres
		WHERE U.Flag = 1 AND D.Flag = 1 AND T.Flag = 1 AND U.IdEmpresa = @IdEmpresaPlantilla

	END

	BEGIN -- ENUMERAR IDENTIFICADORES TEMPORALES ESTRUCTURA 1

		UPDATE D SET
		D.IdEstructuraUno = TEMP.Identificador
		FROM @Data D
		INNER JOIN
		(SELECT  ROW_NUMBER() OVER(ORDER BY IdEstructuraUno) AS Identificador, IdEstructuraUno 
		FROM @Data
		GROUP BY IdEstructuraUno) TEMP ON D.IdEstructuraUno = TEMP.IdEstructuraUno

	END

	BEGIN -- ENUMERAR IDENTIFICADORES TEMPORALES ESTRUCTURA 2

		UPDATE D SET
		D.IdEstructuraDos = TEMP.Identificador
		FROM @Data D
		INNER JOIN
		(SELECT  ROW_NUMBER() OVER(ORDER BY IdEstructuraDos) AS Identificador, IdEstructuraDos 
		FROM @Data
		GROUP BY IdEstructuraDos) TEMP ON D.IdEstructuraDos = TEMP.IdEstructuraDos 

	END

	BEGIN -- ENUMERAR IDENTIFICADORES TEMPORALES ESTRUCTURA 3

		UPDATE D SET
		D.IdEstructuraTres = TEMP.Identificador
		FROM @Data D
		INNER JOIN
		(SELECT  ROW_NUMBER() OVER(ORDER BY IdEstructuraTres) AS Identificador, IdEstructuraTres 
		FROM @Data
		GROUP BY IdEstructuraTres) TEMP ON D.IdEstructuraTres = TEMP.IdEstructuraTres 

	END

	BEGIN -- INSERTAR ESTRUCTURA 1

		DECLARE @TOTAL_UNO INT = (SELECT COUNT(DISTINCT IdEstructuraUno) FROM @Data);
		DECLARE @COUNT_UNO INT = 1;

		WHILE (@COUNT_UNO <= @TOTAL_UNO)
		BEGIN  
	
			INSERT INTO ERP.EstructuraUno (IdEmpresa, Tipo, Nombre, Flag)
			SELECT DISTINCT @IdEmpresa, Tipo, Nombre, 1 FROM @Data WHERE IdEstructuraUno = @COUNT_UNO
	
			DECLARE @ID INT = CAST(SCOPE_IDENTITY() AS int)

			UPDATE @Data SET IdUno = @ID WHERE IdEstructuraUno = @COUNT_UNO

			IF @COUNT_UNO = @TOTAL_UNO
				BREAK;

			SET @COUNT_UNO += 1
		END  

	END

	BEGIN -- INSERTAR ESTRUCTURA 2

		DECLARE @TOTAL_DOS INT = (SELECT COUNT(DISTINCT IdEstructuraDos) FROM @Data);
		DECLARE @COUNT_DOS INT = 1; 

		WHILE (@COUNT_DOS <= @TOTAL_DOS)
		BEGIN  
	
			INSERT INTO ERP.EstructuraDos(IdEstructuraUno, Nombre, Flag)
			SELECT DISTINCT IdUno, NombreEstructuraDos, 1 FROM @Data WHERE IdEstructuraDos = @COUNT_DOS
	
			DECLARE @ID_DOS INT = CAST(SCOPE_IDENTITY() AS int)

			UPDATE @Data SET IdDos = @ID_DOS WHERE IdEstructuraDos = @COUNT_DOS

			IF @COUNT_DOS = @TOTAL_DOS
				BREAK;

			SET @COUNT_DOS += 1
		END 

	END

	BEGIN -- INSERTAR ESTRUCTURA 3 y 4

		DECLARE @TOTAL_TRES INT = (SELECT COUNT(DISTINCT IdEstructuraTres) FROM @Data);
		DECLARE @COUNT_TRES INT = 1; 

		WHILE (@COUNT_TRES <= @TOTAL_TRES)
		BEGIN  
	
			INSERT INTO ERP.EstructuraTres(IdEstructuraDos, Nombre, Orden, Flag)
			SELECT DISTINCT IdDos, NombreEstructuraTres, Orden, 1 FROM @Data WHERE IdEstructuraTres = @COUNT_TRES
	
			DECLARE @ID_TRES INT = CAST(SCOPE_IDENTITY() AS int)

			UPDATE @Data SET IdTres = @ID_TRES WHERE IdEstructuraTres = @COUNT_TRES

			IF @COUNT_TRES = @TOTAL_TRES
				BREAK;

			SET @COUNT_TRES += 1
		END 

		INSERT INTO ERP.EstructuraCuatro (IdEstructuraTres, CuentaContable, Operador, Flag)
		SELECT IdTres, CuentaContable, Operador, 1 FROM @Data WHERE IdEstructuraCuatro IS NOT NULL AND Flag = 1

	END

	SELECT 1;
END
