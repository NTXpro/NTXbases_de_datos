CREATE PROC [ERP].[Usp_Del_AplicacionAnticipoPagar]
@IdAplicacionAnticipo INT
AS
BEGIN

				DECLARE @IdCuentaPagar INT = (SELECT IdCuentaPagar FROM ERP.AplicacionAnticipoPagar WHERE ID = @IdAplicacionAnticipo)

				/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR CABECERA*****************************/

					UPDATE ERP.CuentaPagar SET FlagCancelo = 0
											WHERE ID = @IdCuentaPagar 

				/*********************************************************************************************/


				/********************************ACTUALIZAR FLAGCANCELO CUENTA PAGAR DETALLE*****************************/
					DECLARE @ListaIdCuentaPagarDetale TABLE(INDICE INT,ID INT)

					INSERT INTO @ListaIdCuentaPagarDetale
					SELECT ROW_NUMBER() OVER(ORDER BY IdCuentaPagar ASC),IdCuentaPagar FROM ERP.AplicacionAnticipoPagarDetalle WHERE IdAplicacionAnticipo = @IdAplicacionAnticipo


					DECLARE @TOTAL_ITEMS INT = (SELECT COUNT(IdCuentaPagar) FROM ERP.AplicacionAnticipoPagarDetalle WHERE IdAplicacionAnticipo = @IdAplicacionAnticipo)

					DECLARE @i INT = 1;
						WHILE @i <= @TOTAL_ITEMS
						BEGIN
								
								DECLARE @IdCuentaPagarDetalle INT = (SELECT ID FROM @ListaIdCuentaPagarDetale WHERE INDICE = @i)

										UPDATE ERP.CuentaPagar SET FlagCancelo = 0
											WHERE ID = @IdCuentaPagarDetalle 

						SET @i = @i + 1

						END
				/*********************************************************************************************/



			DELETE ERP.AplicacionAnticipoPagarDetalle WHERE IdAplicacionAnticipo = @IdAplicacionAnticipo

			UPDATE ERP.CuentaPagar SET FlagAnticipo = 0 WHERE ID = @IdCuentaPagar
			
			DECLARE @IdAsiento INT = (SELECT IdAsiento FROM ERP.AplicacionAnticipoPagar WHERE ID = @IdAplicacionAnticipo)

			EXEC ERP.Usp_Upd_AsientoContable_CuentaPagar_Anulado @IdAsiento

			UPDATE ERP.AplicacionAnticipoPagar SET Flag = 0 WHERE ID = @IdAplicacionAnticipo

			DELETE ERP.AplicacionAnticipoPagar WHERE ID = @IdAplicacionAnticipo
END