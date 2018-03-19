use DATALAB


drop table #ConsConSeg
SELECT a.CodPais, a.AnioCampana, a.PKEbelista, a.PKTerritorio, a.FlagPasoPedido, a.FlagActiva, a.DescripcionRolling, b.AnioCampanaIngreso, b.FechaNacimiento, b.AnioCampanaUltimoPedido
into #ConsConSeg
from DWH_ANALITICO.dbo.DWH_FSTAEBECAM a
inner join DWH_ANALITICO.dbo.DWH_DEBELISTA b on a.PKEbelista = b.PKEbelista and a.CodPais = b.CodPais
WHERE a.CodPais = 'PE' and DescripcionRolling not like 'Sin Segmento' and AnioCampana in ('201618', '201718')
order by DescripcionRolling
--(345513 row(s) affected)

drop table #cfg
select PkEbelista, count(PkEbelista) as counts into #cfg from #ConsConSeg group by PKEbelista order by counts asc

drop table #AmbasCampañas
select PkEbelista into #AmbasCampañas from #cfg where counts > 1
select * from #AmbasCampañas order by PKEbelista



drop table #MuestraDePk
SELECT * into #MuestraDePk FROM #AmbasCampañas
WHERE (ABS(CAST((BINARY_CHECKSUM(PKEbelista, NEWID())) as int))% 100) < 10

select * from #MuestraDePk
--8235

select a.* into #muestrainfocons
from #ConsConSeg a inner join #MuestraDePk b on a.PKEbelista = b.PKEbelista 

select * from #muestrainfocons
--16470



drop table #muestraventa
select a.PKEbelista, b.PKProducto, b.PKTipoOferta,
b.RealUUVendidas as RealUUVendidas,
b.RealUUFaltantes as RealUUFaltantes,
b.RealUUDevueltas as [RealUUDevueltas],
b.RealUUAnuladas as RealUUAnuladas,
b.RealVtaMNNeto as RealVtaMNNeto,
b.RealVtaMNFaltNeto as RealVtaMNFaltNeto,
b.RealDevMNNeto as RealDevMNNeto,
b.RealAnulMNNeto as RealAnulMNNeto
INTO #cfg1
from #muestrainfocons a 
inner join DWH_ANALITICO.DBO.DWH_FVTAPROEBECAM b 
on a.PKEbelista = b.PKEbelista and a.AnioCampana = b.AnioCampana and a.CodPais=b.CodPais
where a.CodPais = 'PE' and b.AnioCampana = b.AnioCampanaRef

select * from #cfg1
