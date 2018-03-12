--queries de exploracion que se hicieron para colombia

select  *
from DNROFACTURA
WHERE PKEbelista in (select PKEbelista from #tmp_mil) and AnioCampana = '201718'
order by FechaEmisionFactura desc

SELECT * 
FROM DEBELISTA
WHERE PKEbelista =272722
  
select  *
from DNROFACTURA
WHERE PKEbelista = 272722 and AnioCampana = '201718'


select * from #TMP_ODD2
SELECT *
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201', '202', '203', '204', '205', '206',
'207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224',
'225', '226', '227', '228') AND PKEbelista IN (SELECT DISTINCT PKEbelista FROM #TMP_ODD) --and CodVenta
AND DesCatalogo = '46 - WEB OFERTAS DEL DÍA'


select  *
from DNROFACTURA
WHERE PKEbelista in (select PKEbelista from #tmp_mil) and AnioCampana = '201718'
order by FechaEmisionFactura desc

--para ejercicio de comparación de fechas. pero no central
select DesPalanca, max(FechaEmisionFactura) 
from FResultadoPalancas a inner join DNROFACTURA B ON a.AnioCampana = b.AnioCampana AND A.PKEbelista = B.PkEbelista
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
and DesPalanca <> 'PASO PEDIDO'
where b.AnioCampana = '201718'
group by DesPalanca

select Max(FechaEmisionFactura)
from DNROFACTURA
where AnioCampana ='201718'

--provisional
DROP TABLE #TMP_ODD
SELECT A.*, DesPalanca INTO #TMP_ODD
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') AND C.DesPalanca = 'Ofertas Para tí'
ORDER BY AnioCampana, DesPalanca




drop table #tmp_mil
SELECT distinct PKEbelista into #tmp_mil
FROM FVTAPROEBECAMC01 A INNER JOIN DMATRIZCAMPANA B ON A.AnioCampana = B.AnioCampana and a.CodVenta = b.CodVenta
inner join DTIPOOFERTA c on b.PKTipoOferta = c.PKTipoOferta
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and CodTipoProfit = '01'
and C.CodTipoOferta in ('201', '202', '203', '204', '205', '206',
'207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224',
'225', '226', '227', '228') AND PKEbelista NOT IN (SELECT DISTINCT PKEbelista FROM #TMP_ODD)
AND DesCatalogo = '46 - WEB OFERTAS DEL DÍA' --and a.CodVenta ='97684'


--ya etapa de exploración
drop table #PkEbe
SELECT distinct PkEbelista into #PkEbe
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef and d.CodSeccion = 9

drop table #PkEbe2
SELECT PkEbelista, CodVenta into #PkEbe2
FROM FResultadoPalancas A INNER JOIN DTIPOOFERTA B ON A.CodTipoOferta = B.CodTipoOferta 
INNER JOIN DPALANCAS C ON A.PkPalanca = C.PkPalanca
WHERE CodTipoProfit = '01' AND AnioCampana IN ('201718') AND DESPALANCA <> 'Paso Pedido' and DesPalanca = 'Ofertas del Día'
and PkEbelista not in (select PKEbelista from #PkEbe)



--para validar estos CodEbelista y CodVenta como digitacion de CodVentas que nunca recibieron
SELECT DISTINCT CodEbelista, a.CodVenta , DesMedio
FROM FVTAPROEBECAMC01 A INNER JOIN DOrigenPedidoWeb D ON A.CodigoPalanca = D.OrigenPedidoWeb
inner join #PkEbe2 b on b.PkEbelista = a.PkEbelista and b.CodVenta = a.CodVenta
inner join DEBELISTA E on E.PkEbelista = A.PkEbelista
where a.AnioCampana IN ('201718') and A.AnioCampana = A.AnioCampanaRef
--probar con una tubla de CodEbelista y CodVenta  sacado del query de arriba
--Personalización
select CodEbelista, CodVenta, *
from arp_ofertapersonalizadac01 
WHERE CodPais = 'CO' and AnioCampanaVenta = '201718' and TipoPersonalizacion = 'SR'
and CodEbelista = '9900050750'
and CodVenta ='97140'

--TiposPersonalizacion: ODD, OPT, SR

--Parámetros ARP
SELECT * FROM ARP_PARAMETROS WHERE CodPais = 'CO' AND AnioCampanaExpo = '201718'



