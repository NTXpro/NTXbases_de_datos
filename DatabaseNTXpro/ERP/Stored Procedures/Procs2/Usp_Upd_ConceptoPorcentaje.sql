CREATE PROC [ERP].[Usp_Upd_ConceptoPorcentaje]
@ID INT,
@IdConcepto INT,
@IdAnio INT,
@IdRegimenLaboral INT,
@XMLConceptoPorcentajeMes XML,
@XMLConceptoPorcentajeMesDetalle XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000
	DECLARE @TABLE_DETALLE TABLE(ID INT, IdConcepto INT, IdMes INT);
	INSERT INTO @TABLE_DETALLE
	SELECT
		T.N.value('ID[1]', 'INT'),
		T.N.value('IdConcepto[1]', 'INT'),
		T.N.value('IdMes[1]', 'INT')
	FROM @XMLConceptoPorcentajeMesDetalle.nodes('/SubAnonimo') AS T(N)

	IF(@ID = 0)
	BEGIN
		DECLARE @C INT = 1;

		INSERT INTO [ERP].[ConceptoPorcentaje] ([IdConcepto], [IdAnio], [IdRegimenLaboral])
		VALUES (@IdConcepto, @IdAnio, @IdRegimenLaboral)
		SET @ID = CAST(SCOPE_IDENTITY() AS INT)
		
		WHILE (@C <= 12)
		BEGIN  
	
			INSERT INTO [ERP].[ConceptoPorcentajeMes] ([IdConceptoPorcentaje], [IdMes], [Porcentaje])
			SELECT 	
				@ID,
				T.N.value('IdMes[1]', 'INT'),
				T.N.value('Porcentaje[1]', 'DECIMAL(18,2)')
			FROM
			@XMLConceptoPorcentajeMes.nodes('/Anonimo') AS T(N)
			INNER JOIN Maestro.Mes M ON T.N.value('IdMes[1]', 'INT') = M.ID
			WHERE M.Valor = @C
	
			DECLARE @SUB_ID INT = CAST(SCOPE_IDENTITY() AS INT)

			INSERT INTO [ERP].[ConceptoPorcentajeMesDetalle]
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

		DELETE CPMD
		FROM [ERP].[ConceptoPorcentajeMesDetalle] CPMD
		INNER JOIN [ERP].[ConceptoPorcentajeMes] CPM ON CPMD.IdConceptoPorcentajeMes = CPM.ID
		INNER JOIN [ERP].[ConceptoPorcentaje] CP ON CPM.IdConceptoPorcentaje = CP.ID
		WHERE 
		CP.ID = @ID AND
		CPMD.ID NOT IN (SELECT ID FROM @TABLE_DETALLE)

		UPDATE CPM SET
		CPM.Porcentaje = T.N.value('Porcentaje[1]', 'DECIMAL(18,2)')
		FROM [ERP].[ConceptoPorcentajeMes] CPM
		INNER JOIN @XMLConceptoPorcentajeMes.nodes('/Anonimo') AS T(N) ON CPM.IdMes = T.N.value('IdMes[1]', 'INT')
		WHERE CPM.IdConceptoPorcentaje = @ID

		DECLARE @C2 INT = 1;	
		WHILE (@C2 <= 12)
		BEGIN  

			DECLARE @SUB_ID2 INT;
			DECLARE @PORCENTAJE DECIMAL(18,2);
			SELECT 
				@SUB_ID2 = CPM.ID,
				@PORCENTAJE = T.N.value('Porcentaje[1]', 'DECIMAL(18,2)')
			FROM @XMLConceptoPorcentajeMes.nodes('/Anonimo') AS T(N)
			INNER JOIN [ERP].[ConceptoPorcentajeMes] CPM ON T.N.value('IdMes[1]', 'INT') = CPM.IdMes
			WHERE 
			T.N.value('IdMes[1]', 'INT') = @C2 AND
			CPM.IdConceptoPorcentaje = @ID

			/*UPDATE [ERP].[ConceptoPorcentajeMes] SET
			Porcentaje = @PORCENTAJE
			WHERE ID = @SUB_ID2;*/

			-- DETALLE
			INSERT INTO [ERP].[ConceptoPorcentajeMesDetalle]
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
