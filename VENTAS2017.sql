use DATALAB



--obteniendo muestra de PK
drop table #ListaPk
SELECT distinct PKEbelista, CodPais into #ListaPk
FROM [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM]
where CodPais = 'PE' AND AnioCampana = '201609'
--(1439202 row(s) affected)


drop table #MuestraDePk
SELECT * into #MuestraDePk FROM #ListaPk
WHERE (ABS(CAST((BINARY_CHECKSUM(PKEbelista, NEWID())) as int))% 100) < 10

select * from #MuestraDePk
--143796

DROP TABLE #AniosCamps
select distinct AnioCampana into #AniosCamps
from [DWH_ANALITICO].[dbo].[DWH_FSTAEBECAM]

drop table #ListaPkEbe
SELECT * into #ListaPkEbe
FROM  #MuestraDePk CROSS JOIN #AniosCamps
order by PKEbelista
--((4457676 row(s) affected)

drop table ventas2017
select a.PKEbelista, a.AnioCampana,  
sum([RealUUVendidas]) as RealUUVendidas,
sum([RealUUFaltantes]) as RealUUFaltantes,
sum([RealUUDevueltas]) as [RealUUDevueltas],
sum(RealUUAnuladas) as RealUUAnuladas,
sum(RealVtaMNNeto) as RealVtaMNNeto,
sum(RealVtaMNFaltNeto) as RealVtaMNFaltNeto,
sum(RealDevMNNeto) as RealDevMNNeto,
sum(RealAnulMNNeto) as RealAnulMNNeto
INTO ventas2017
from #ListaPkEbe a left join DWH_ANALITICO.DBO.DWH_FVTAPROEBECAM b on a.PKEbelista = b.PKEbelista and a.CodPais = b.CodPais and a.AnioCampana = b.AnioCampana
group by a.PKEbelista, a.AnioCampana
order by a.PKEbelista, a.AnioCampana

select * from ventas2017

select distinct Pkebelista from ventas2017

drop table #pdp
select AnioCampana, sum(realVtaMNNeto) as total_ventas, COUNT(realvtaMNnETO) as total_pedidos
into #pdp
from ventas2017
group by AnioCampana
order by AnioCampana

drop table pdp
select *, total_ventas/total_pedidos as p$p
into pdp
from #pdp

select * from pdp
--podria ser que empiezar a disminuir su venta cuando entran nuevas consultoras cerca a ella

