CREATE PROC ERP.Usp_Del_AplicacionAnticipoCobrar
@IdAplicacionAnticipo INT
AS
BEGIN
			DECLARE @IdCuentaCobrar INT = (SELECT IdCuentaCobrar FROM ERP.AplicacionAnticipoCobrar WHERE ID = @IdAplicacionAnticipo)

			/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR CABECERA*****************************/

					UPDATE ERP.CuentaCobrar SET FlagCancelo = 0
											WHERE ID = @IdCuentaCobrar 

			/*********************************************************************************************/

			/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR DETALLE*****************************/
					DECLARE @ListaIdCuentaCobrarDetale TABLE(INDICE INT,ID INT)

					INSERT INTO @ListaIdCuentaCobrarDetale
					SELECT ROW_NUMBER() OVER(ORDER BY IdCuentaCobrar ASC),IdCuentaCobrar FROM ERP.AplicacionAnticipoCobrarDetalle WHERE IdAplicacionAnticipoCobrar = @IdAplicacionAnticipo


					DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(IdCuentaCobrar) FROM ERP.AplicacionAnticipoCobrarDetalle WHERE IdAplicacionAnticipoCobrar = @IdAplicacionAnticipo)

					DECLARE @i INT = 1;
						WHILE @i <= @TOTAL_ITEMS
						BEGIN
								
								DECLARE @IdCuentaCobrarDetalle INT = (SELECT ID FROM @ListaIdCuentaCobrarDetale WHERE INDICE = @i)

										UPDATE ERP.CuentaCobrar SET FlagCancelo = 0
											WHERE ID = @IdCuentaCobrarDetalle 

						SET @i = @i + 1

						END
			/*********************************************************************************************/

			DELETE ERP.AplicacionAnticipoCobrarDetalle WHERE IdAplicacionAnticipoCobrar = @IdAplicacionAnticipo

			UPDATE ERP.CuentaCobrar SET FlagAnticipo = 0 WHERE ID = @IdCuentaCobrar
			
			DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.AplicacionAnticipoCobrar WHERE ID = @IdAplicacionAnticipo)

			EXEC ERP.Usp_Upd_AsientoContable_CuentaCobrar_Anulado @IdAsiento

			UPDATE ERP.AplicacionAnticipoCobrar SET Flag = 0 WHERE ID = @IdAplicacionAnticipo
END
