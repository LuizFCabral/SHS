<%-- 
CONTROLE DO MOVIMENTO ===============================================
Esta página serve para o controle e registro das movimentações que 
ocorrem no estoque de vacinas: entrada e saída de lotes/doses de vacinas. Uma coisa
importante a notar-se é que movimentos de entrada, tais como foram 
programados neste projeto, significam exclusivamente entrada de um lote 
inteiro de uma certa vacina. Assim fizemos para manter a coerência no código.
Não ocorre nenhuma especificidade quanto à saída.
--%>

<%@page import="controller.LoteJpaController"%>
<%@page import="model.*"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="controller.VacinaJpaController"%>
<%@page import="controller.DAOJPA"%>
<%@page import="controller.UsuarioJpaController"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.Vacina"%>
<%@page import="java.util.List"%>
<%@page import="controller.MovimentoVacinaJpaController"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="estilo/style.css">
        <title>Consulta de movimentos</title>
    </head>
    <body>
        <div class="home_content">
            <div class="title">Gerenciamento de estoque - Movimentos</div>
<%
            request.setCharacterEncoding("UTF-8");
            MovimentoVacina obj;
            String b;
            MovimentoVacinaJpaController dao;
            VacinaJpaController daoV;
            DAOJPA daoJ;
            Banco bb = new Banco();
            Lote l;
            try 
            {
                if(session.getAttribute("login") == null || session.getAttribute("classe") != UsuarioApl.class || 
                        !((UsuarioApl)session.getAttribute("login")).getTipoPessoa().equals("G"))
                    throw new Exception("Log-in não feito ou credenciais insuficientes");
                dao = new MovimentoVacinaJpaController(Banco.conexao);
                daoV = new VacinaJpaController(Banco.conexao);
                SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
                SimpleDateFormat tF = new SimpleDateFormat("dd/MM/yyyy HH:mm"); //Formatador geral
                SimpleDateFormat hF = new SimpleDateFormat("HH:mm"); //Formatador de horas
                
                //código de mesma estrutura dos CRUDs, consultá-los caso haja necessidade de melhor entendimento do seu funcionamento.
                if(request.getParameter("b1") == null)
                {
                    if(request.getParameter("bCarregar") == null)
                    {
%>                      
                        <form action="controleMovimento.jsp" method="post" onsubmit="return verificar(1)">
                            <div class="user-data">
                                <div class="input-box">
                                    <span class="data">Código</span>
                                    <input type="text" name="txtCod" placeholder="Digite o código do movimento: "/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Código da vacina</span>
                                    <input type="text" name="txtCodVac" placeholder="Digite o código da vacina: "/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Data do movimento</span>
                                    <input type="text" name="txtDataMov" placeholder="Digite a data do movimento: "/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Hora do movimento</span>
                                    <input type="text" name="txtHoraMov" placeholder="Digite a hora do movimento: "/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Tipo do movimento</span>
                                    <input type="text" name="txtTipo" placeholder="Digite o tipo do movimento: "/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Quantidade</span>
                                    <input type="text" name="txtQuant" placeholder="Digite a quantidade: "/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Lote</span>
                                    <input type="text" name="txtLote" placeholder="Digite o lote: "/>
                                </div>
                            </div>
                            <div class="button">
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                            </div>
                        </form>
<%
                    }
                    else
                    {
                        obj = dao.findMovimentoVacina(Integer.parseInt(request.getParameter("bCarregar")));
%>
                        <form action="controleMovimento.jsp" method="post" onsubmit="return verificar(1)">
                            <div class="user-data">
                                <div class="input-box">
                                    <span class="data">Código</span>
                                    <input type="text" name="txtCod" value="<%=obj.getCodigo()%>"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Código da vacina</span>
                                    <input type="text" name="txtCodVac" value="<%=obj.getCodigoVacina().getCodigo()%>"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Data do movimento</span>
                                    <input type="text" name="txtDataMov" value="<%=dF.format(obj.getDataMovimento())%>"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Hora do movimento</span>
                                    <input type="text" name="txtHoraMov" value="<%=hF.format(obj.getDataMovimento())%>"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Quantidade</span>
                                    <input type="text" name="txtQuant" value="<%=obj.getQtdeDose()%>"/>
                                </div>
                                <div class="input-box">
                                    <span class="data">Lote</span>
                                    <input type="text" name="txtLote" value="<%=obj.getCodigoLote().getDescricao()%>"/>
                                </div>
                            </div>
                            <div class="button">
                                <input type="submit" name="b1" value="Cadastrar" onclick="definir(0)"/>&nbsp;&nbsp;
                                <input type="submit" name="b1" value="Remover" onclick="definir(2)"/>&nbs  p;&nbsp;
                                <input type="submit" name="b1" value="Consultar" onclick="definir(3)"/>
                            </div>
                        </form>
<%
                    }
                }
                else
                {
                    b = request.getParameter("b1");
                    int cod;
                    switch(b)
                    {
                        case "Cadastrar":
                            obj = new MovimentoVacina();
                            obj.setCodigoVacina(daoV.findVacina(Integer.parseInt(request.getParameter("txtCodVac"))));
                            obj.setDataMovimento(tF.parse(request.getParameter("txtDataMov") + " " + request.getParameter("txtHoraMov")));
                            int dose, uni;
                            uni = Integer.parseInt(request.getParameter("txtQuant"));
                            dose = uni * obj.getCodigoVacina().getQtdeDose();
                            obj.setTipoMovimento("E");
                            obj.setQtdeDose(dose);
                            daoJ = new DAOJPA();
                            l = daoJ.loteByDescricao(bb, request.getParameter("txtLote"));
                            if(l == null)
                            {
                                l = new Lote();
                                l.setDescricao(request.getParameter("txtLote"));
                                l.setCodigoVacina(obj.getCodigoVacina());
                                l.setDoseDisponivel(dose);
                                l.setQtdeUnidade(uni);
                                LoteJpaController daoL = new LoteJpaController(Banco.conexao);
                                daoL.create(l);
                            }
                            obj.setCodigoLote(daoJ.loteByDescricao(bb, request.getParameter("txtLote")));
                            dao.create(obj);
%> 
                            <h1>Movimento de <%=obj.completarTipo()%> cadastrado com sucesso.</h1>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
                            break;
                            
                        case "Remover":
                            cod = Integer.parseInt(request.getParameter("txtCod"));
                            obj = dao.findMovimentoVacina(cod);
                            if(obj == null)
                                throw new Exception("Esse movimento não existe.");
                            if(!obj.getTipoMovimento().equals("S"))
                                throw new Exception("Apenas movimentos de entrada podem ser removidos");
                            LoteJpaController daoL = new LoteJpaController(Banco.conexao);
                            l = obj.getCodigoLote();
                            l.setDoseDisponivel(l.getDoseDisponivel() - obj.getQtdeDose());
                            daoL.edit(l);
                            dao.destroy(cod);
%>
                           <h1>Movimento de <%=obj.completarTipo()%> removido com sucesso.</h1>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
                            break;
                            
                        case "Consultar":
                            List<MovimentoVacina> lista = dao.findMovimentoVacinaEntities();
                            if(lista == null || lista.isEmpty())
                            {
                                throw new Exception("Lista nula ou vazia.");
                            }
                            else
                            {
                                String aux = "";
                                if(lista.size() > 1)
                                    aux = "s";
%>
                                <h1>Lista com <%=lista.size()%> movimento<%=aux%> encontrado<%=aux%></h1>
                                    <table border="1">
                                        <thead>
                                            <tr>
                                                <th>Código</th>
                                                <th>Código da vacina</th>
                                                <th>Data do movimento</th>
                                                <th>Hora do movimento</th>
                                                <th>Tipo</th>
                                                <th>Quantidade</th>
                                                <th>Lote</th>
                                            </tr>
                                        </thead>
                                        <tbody>
<%
                                        for(int i = 0; i < lista.size(); i++)
                                        {
                                            obj = lista.get(i);
%>
                                            <tr>
                                                <td><a href="controleMovimento.jsp?bCarregar=<%=obj.getCodigo()%>"><%=obj.getCodigo()%></a></td>
                                                <td><%=obj.getCodigoVacina().getCodigo()%></td>
                                                <td><%=dF.format(obj.getDataMovimento())%></td>
                                                <td><%=hF.format(obj.getDataMovimento())%></td>
                                                <td><%=obj.completarTipo()%></td>
                                                <td><%=obj.getQtdeDose()%></td>
                                                <td><%=obj.getCodigoLote().getDescricao()%></td>
                                            </tr>
<%
                                        }
%>
                                        </tbody>
                                    </table>
                                Selecione o campo código de um movimento para carregar seus dados no formulário.<br/>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
                            }
                            break;

                        default:
                            throw new Exception("Erro inesperado ao ler evento do botão.");
                    }
                    Banco.conexao.close();
                }
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
%>
<h1>Erro: <%=ex.getMessage()%></h1>Clique <a href="controleMovimento.jsp">aqui</a> para voltar ao controle de movimento
<%
            }
%>
        </div>
    </body>
</html>
