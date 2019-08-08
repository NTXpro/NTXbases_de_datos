CREATE PROC [ERP].[Usp_Upd_ConceptoHora]
@ID INT,
@IdConcepto INT,
@IdAnio INT,
@XMLConceptoHoraMes XML,
@XMLConceptoHoraMesDetalle XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	DECLARE @TABLE_DETALLE TABLE(ID INT, IdConcepto INT, IdMes INT);
	INSERT INTO @TABLE_DETALLE
	SELECT
		T.N.value('ID[1]', 'INT'),
		T.N.value('IdConcepto[1]', 'INT'),
		T.N.value('IdMes[1]', 'INT')
	FROM @XMLConceptoHoraMesDetalle.nodes('/CHSubAnonimo') AS T(N)

	IF(@ID = 0)
	BEGIN
		DECLARE @C INT = 1;

		INSERT INTO [ERP].[ConceptoHora] ([IdConcepto], [IdAnio])
		VALUES (@IdConcepto, @IdAnio)
		SET @ID = CAST(SCOPE_IDENTITY() AS INT)
		
		WHILE (@C <= 12)
		BEGIN  
	
			INSERT INTO [ERP].[ConceptoHoraMes] ([IdConceptoHora], [IdMes], [Factor])
			SELECT 	
				@ID,
				T.N.value('IdMes[1]', 'INT'),
				T.N.value('Factor[1]', 'DECIMAL(18,2)')
			FROM
			@XMLConceptoHoraMes.nodes('/CHAnonimo') AS T(N)
			INNER JOIN Maestro.Mes M ON T.N.value('IdMes[1]', 'INT') = M.ID
			WHERE M.Valor = @C
	
			DECLARE @SUB_ID INT = CAST(SCOPE_IDENTITY() AS INT)

			INSERT INTO [ERP].[ConceptoHoraMesDetalle]
			SELECT 	
				@SUB_ID,
				TD.IdConcepto
			FROM @TABLE_DETALLE TD
			INNER JOIN Maestro.Mes M ON TD.IdMes = M.ID
			WHERE M.Valor = @C

			SET @C += 1
		END
	END
	ELSE
	BEGIN

		DELETE CHMD
		FROM [ERP].[ConceptoHoraMesDetalle] CHMD
		INNER JOIN [ERP].[ConceptoHoraMes] CHM ON CHMD.IdConceptoHoraMes = CHM.ID
		INNER JOIN [ERP].[ConceptoHora] CH ON CHM.IdConceptoHora = CH.ID
		WHERE 
		CH.ID = @ID AND
		CHMD.ID NOT IN (SELECT ID FROM @TABLE_DETALLE)

		UPDATE CHM SET
		CHM.Factor = T.N.value('Factor[1]', 'DECIMAL(18,2)')
		FROM [ERP].[ConceptoHoraMes] CHM
		INNER JOIN @XMLConceptoHoraMes.nodes('/CHAnonimo') AS T(N) ON CHM.IdMes = T.N.value('IdMes[1]', 'INT')
		WHERE CHM.IdConceptoHora = @ID

		DECLARE @C2 INT = 1;	
		WHILE (@C2 <= 12)
		BEGIN  

			DECLARE @SUB_ID2 INT;
			DECLARE @FACTOR DECIMAL(18,2);
			SELECT 
				@SUB_ID2 = CHM.ID,
				@FACTOR = T.N.value('Factor[1]', 'DECIMAL(18,2)')
			FROM @XMLConceptoHoraMes.nodes('/CHAnonimo') AS T(N)
			INNER JOIN [ERP].[ConceptoHoraMes] CHM ON T.N.value('IdMes[1]', 'INT') = CHM.IdMes
			WHERE 
			T.N.value('IdMes[1]', 'INT') = @C2 AND
			CHM.IdConceptoHora = @ID

			/*UPDATE [ERP].[ConceptoHoraMes] SET
			Factor = @FACTOR
			WHERE ID = @SUB_ID2;*/

			-- DETALLE
			INSERT INTO [ERP].[ConceptoHoraMesDetalle]
			SELECT 	
				@SUB_ID2,
				TD.IdConcepto
			FROM @TABLE_DETALLE TD
			INNER JOIN Maestro.Mes M ON TD.IdMes = M.ID
			WHERE 
			M.Valor = @C2 AND
			TD.ID = 0;

			SET @C2 += 1
		END
	END
	SELECT 1;
END
