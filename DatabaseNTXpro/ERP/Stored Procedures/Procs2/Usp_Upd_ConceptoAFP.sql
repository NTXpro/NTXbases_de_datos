CREATE PROC [ERP].[Usp_Upd_ConceptoAFP]
@ID INT,
@IdConcepto INT,
@IdAnio INT,
@IdRegimenLaboral INT,
@XMLConceptoAFPMes XML,
@XMLConceptoAFPMesPorcentaje XML,
@XMLConceptoAFPMesDetalle XML
AS
BEGIN
	SET QUERY_GOVERNOR_COST_LIMIT 36000;
	DECLARE @TABLE_DETALLE_PORCENTAJE TABLE(ID INT, IdAFP INT, IdMes INT, Porcentaje DECIMAL(18,2));
	DECLARE @TABLE_DETALLE TABLE(ID INT, IdConcepto INT, IdMes INT);
	INSERT INTO @TABLE_DETALLE_PORCENTAJE
	SELECT
		T.N.value('ID[1]', 'INT'),
		T.N.value('IdAFP[1]', 'INT'),
		T.N.value('IdMes[1]', 'INT'),
		T.N.value('Porcentaje[1]', 'DECIMAL(18,2)')
	FROM @XMLConceptoAFPMesPorcentaje.nodes('/CAPAnonimo') AS T(N)
	INSERT INTO @TABLE_DETALLE
	SELECT
		T.N.value('ID[1]', 'INT'),
		T.N.value('IdConcepto[1]', 'INT'),
		T.N.value('IdMes[1]', 'INT')
	FROM @XMLConceptoAFPMesDetalle.nodes('/CASubAnonimo') AS T(N)

	IF(@ID = 0)
	BEGIN
		DECLARE @C INT = 1;

		INSERT INTO [ERP].[ConceptoAFP] ([IdConcepto], [IdAnio], [IdRegimenLaboral])
		VALUES (@IdConcepto, @IdAnio, @IdRegimenLaboral)
		SET @ID = CAST(SCOPE_IDENTITY() AS INT)
		
		WHILE (@C <= 12)
		BEGIN  
	
			INSERT INTO [ERP].[ConceptoAFPMes] ([IdConceptoAFP], [IdMes])
			SELECT 	
				@ID,
				T.N.value('IdMes[1]', 'INT')
			FROM
			@XMLConceptoAFPMes.nodes('/CAAnonimo') AS T(N)
			INNER JOIN Maestro.Mes M ON T.N.value('IdMes[1]', 'INT') = M.ID
			WHERE M.Valor = @C
	
			DECLARE @SUB_ID INT = CAST(SCOPE_IDENTITY() AS INT)

			INSERT INTO [ERP].[ConceptoAFPMesPorcentaje]
			SELECT 	
				@SUB_ID,
				TDP.IdAFP,
				TDP.Porcentaje
			FROM @TABLE_DETALLE_PORCENTAJE TDP
			INNER JOIN Maestro.Mes M ON TDP.IdMes = M.ID
			WHERE M.Valor = @C

			INSERT INTO [ERP].[ConceptoAFPMesDetalle]
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
		FROM [ERP].[ConceptoAFPMesDetalle] CPMD
		INNER JOIN [ERP].[ConceptoAFPMes] CPM ON CPMD.IdConceptoAFPMes = CPM.ID
		INNER JOIN [ERP].[ConceptoAFP] CP ON CPM.IdConceptoAFP = CP.ID
		WHERE 
		CP.ID = @ID AND
		CPMD.ID NOT IN (SELECT ID FROM @TABLE_DETALLE)

		UPDATE CAMP SET CAMP.Porcentaje = TDP.Porcentaje
		FROM [ERP].[ConceptoAFPMesPorcentaje] CAMP
		INNER JOIN @TABLE_DETALLE_PORCENTAJE TDP ON CAMP.ID = TDP.ID
		WHERE TDP.ID > 0;

		DECLARE @C2 INT = 1;	
		WHILE (@C2 <= 12)
		BEGIN  

			DECLARE @SUB_ID2 INT;
			SELECT 
				@SUB_ID2 = CAM.ID
			FROM @XMLConceptoAFPMes.nodes('/CAAnonimo') AS T(N)
			INNER JOIN [ConceptoAFPMes] CAM ON T.N.value('IdMes[1]', 'INT') = CAM.IdMes
			WHERE 
			T.N.value('IdMes[1]', 'INT') = @C2 AND
			CAM.IdConceptoAFP = @ID;

			-- DETALLE PORCENTAJE INSERT
			INSERT INTO [ERP].[ConceptoAFPMesPorcentaje]
			SELECT 	
				@SUB_ID2,
				TDP.IdAFP,
				TDP.Porcentaje
			FROM @TABLE_DETALLE_PORCENTAJE TDP
			INNER JOIN Maestro.Mes M ON TDP.IdMes = M.ID
			WHERE 
			M.Valor = @C2 AND
			TDP.ID = 0;

			-- DETALLE
			INSERT INTO [ERP].[ConceptoAFPMesDetalle]
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
