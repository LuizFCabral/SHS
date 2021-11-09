<%-- 
    Document   : atualizarVacina
    Created on : 09/10/2021, 17:14:15
    Author     : Pedro
--%>

<%@page import="controller.*"%>
<%@page import="java.util.List"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Confirmar aplicação de vacina</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script type="text/javascript">
            var prox = true;
            
            function prosseguir()
            {
                return prox;
            }
            function confirmar()
            {
                var r = confirm("Este usuário não possui um agendamento. Continuar irá permitir que seja vacinado agora.");
                prox = r;
            }
        </script>
    </head>
    <body>
        <div class="home_content">
        <div class="title">Aplicação de vacina</div>
        <%
            request.setCharacterEncoding("UTF-8");
            Usuario u = new Usuario();
            Banco bb = new Banco();
            DAOJPA daoJ = new DAOJPA();
            SimpleDateFormat dF = new SimpleDateFormat("dd/MM/yyyy"); //Formatador de datas
            SimpleDateFormat tF = new SimpleDateFormat("yyyy-MM-dd HH:mm"); //Formatador geral
            SimpleDateFormat hF = new SimpleDateFormat("HH:mm"); //Formatador de hora
            MovimentoVacinaJpaController dao = new MovimentoVacinaJpaController(Banco.conexao);
            Timestamp hoje = new Timestamp(System.currentTimeMillis());
            UsuarioApl apl;
            try
            {
                if(session.getAttribute("login") == null || session.getAttribute("classe") != UsuarioApl.class)
                    throw new Exception("Log-in não feito ou credenciais insuficientes");
                apl = (UsuarioApl)session.getAttribute("login");
                if(request.getParameter("b1") == null)
                {
        %>
        <form action="atualizarVacina.jsp">
            <div class="user-data">
                <div class="input-box">
                    <span class="data">CPF da pessoa a ser vacinada</span>
                    <input type="text" name="txtCPF" placeholder="Insira o CPF"/>
                </div>
            </div>
            <div class="button">
                <input type="submit" name="b1" value="Procurar"/>
            </div>
        </form>
        <%
                }
                else
                {
                    if(request.getParameter("b1").equalsIgnoreCase("Procurar"))
                    {
                        u = (Usuario) daoJ.searchCPF(bb, request.getParameter("txtCPF"), u.getClass());
        %>
                    <form action="atualizarVacina.jsp" onsubmit="return prosseguir()">
                        <h1>Dados da pessoa</h1>
                        <div class="user-data">
                            <div class="input-box">
                                <span class="data">CPF</span>
                                <input type="text" name="txtCPF" value="<%=u.getCpf()%>" readonly/> <br/>
                            </div>
                            <div class="input-box">
                                <span class="data">Código</span>
                                <input type="text" name="txtCodigo" value="<%=u.getCodigo()%>" readonly/> <br/>
                            </div>
                            <div class="input-box">
                                <span class="data">Nome</span>
                                <input type="text" name="txtNome" value="<%=u.getNome()%>" readonly/> <br/>
                            </div>
                            <div class="input-box">
                                <span class="data">Data de nascimento</span>
                                <input type="text" name="txtDataNasc" value="<%=dF.format(u.getDataNascimento())%>" readonly/> <br/>
                            </div>
                            <div class="input-box">
                                <span class="data">Cidade</span>
                                <input type="text" name="txtCidade" value="<%=u.getCidade()%>" readonly/> <br/>
                            </div>
                        </div>
                        <h1>Agendamento vigente</h1>
                        <%
                            boolean isVigente = false;
                            if(u.getAgendaList().isEmpty())
                            {
                                %><h4>Não há agendamento vigente.</h4><%
                            }
                            else
                            {
                                List<Agenda> lista = u.getAgendaList();
                                for(int i = 0; i < lista.size(); i++)
                                {
                                    if(lista.get(i).getVacinacaoList().isEmpty())
                                    {
                                        Agenda vigente = lista.get(i);
                                        isVigente = true;
                                        %>
                                        <div class="tabela" style="overflow-x: auto;">
                                            <table border="1">
                                                <thead>
                                                    <tr>
                                                        <th>Código</th>
                                                        <th>Data de modificação</th>
                                                        <th>Hora de modificação</th>
                                                        <th>Código de usuário</th>
                                                        <th>Data marcada</th>
                                                        <th>Hora marcada</th>
                                                        <th>Número da dose</th>
                                                        <th>Situação</th>
                                                    </tr>
                                                    <tr>
                                                        <td><%=vigente.getCodigo()%></td>
                                                        <td><%=dF.format(vigente.getDataAgendamento())%></td>
                                                        <td><%=hF.format(vigente.getDataAgendamento())%></td>
                                                        <td><%=vigente.getCodigoUsuario().getCodigo()%></td>
                                                        <td><%=dF.format(vigente.getDataVacinacao())%></td>
                                                        <td><%=hF.format(vigente.getDataVacinacao())%></td>
                                                        <td><%=vigente.getDoseNumero()%></td>
                                                        <%
                                                            if(hoje.getDate() == vigente.getDataVacinacao().getDate())
                                                            {
                                                                %><td>dia certo</td><%
                                                            }
                                                            else
                                                            {
                                                                if(hoje.before(vigente.getDataVacinacao()))
                                                                {
                                                                    %><td>adiantado</td><%
                                                                }
                                                                else
                                                                {
                                                                    %><td>atrasado</td><%
                                                                }
                                                            }
                                                        %>
                                                    </tr>
                                                </thead>
                                            </table>
                                        </div>
                            <%
                                        break;
                                    }
                                }
                                if(!isVigente)
                                {
                                    %><h4>Não há agendamento vigente.</h4><%
                                }
                            }
                        %>
                        <h1>Dados da vacina</h1>
                        <div class="user-data">
                            <div class="input-box">
                                <span class="data">Vacina utilizada</span>
                                <input type="text" name="txtDescr" placeholder="Insira o nome da vacina"/><br/>
                            </div>
                            <div class="input-box">
                                <span class="data">Lote utilizado</span>
                                <input type="text" name="txtLote" placeholder="Insira o lote utilizado"/><br/>
                            </div>
                        <%
                            String t = "";
                            if(!isVigente)
                                {
                                    t = "onclick='confirmar()'";
                                    %>
                                    <div class="input-box">
                                        <span class="data"> Número da dose</span>
                                        <input type="text" name="txtNumDose" placeholder="Insira o n. da dose"/>
                                    </div>    
                                        <%
                                }
                        %>
                        </div>
                        <div class="button">
                            <input type="submit" name="b1" <%=t%> value="confirmar"/>
                        </div>
                    </form>
        
        <%
                    }

                    if(request.getParameter("b1").equalsIgnoreCase("confirmar"))
                    {
                        Vacina v = new Vacina();
                        UsuarioJpaController daoU = new UsuarioJpaController(Banco.conexao);
                        int cod = Integer.parseInt(request.getParameter("txtCodigo"));
                        u = daoU.findUsuario(cod); //pega o obj usuário 
                        String descr = request.getParameter("txtDescr");
                        v = daoJ.vacinaByDescr(bb, descr); //pega o obj vacina
                        MovimentoVacina mov = new MovimentoVacina();
                        mov.setTipoMovimento("S");
                        mov.setCodigoVacina(v);
                        mov.setQtdeDose(1);
                        mov.setDataMovimento(hoje);
                        String lote = request.getParameter("txtLote");
                        daoJ = new DAOJPA();
                        Lote l = daoJ.loteByDescricao(bb, lote);
                        mov.setCodigoLote(l);
                        LoteJpaController daoL = new LoteJpaController(Banco.conexao);
                        l.setDoseDisponivel(l.getDoseDisponivel() - 1);
                        daoL.edit(l);
                        dao.create(mov);
                        Vacinacao vac = new Vacinacao();
                        vac.setCodigoLote(l);
                        vac.setCodigoUsuario(u);
                        boolean novo = false;
                        List<Agenda> lista = u.getAgendaList();
                        if(lista == null || lista.isEmpty())
                            novo = true;
                        Agenda a = new Agenda();
                        int i;
                        for(i = 0; i<lista.size(); i++)
                        {
                            a = lista.get(i);
                            if(a.getVacinacaoList().isEmpty())
                            {
                                novo = false;
                                break;
                            }
                        }
                        if(novo)
                        {
                            a = new Agenda();
                            a.setCodigoUsuario(u);
                            a.setDataAgendamento(hoje);
                            a.setDataVacinacao(hoje);
                            a.setDoseNumero(Integer.parseInt(request.getParameter("txtNumDose")));
                            AgendaJpaController daoA = new AgendaJpaController(Banco.conexao);
                            daoA.create(a);
                        }
                        vac.setCodigoAgenda(a);
                        vac.setDataAplicacao(hoje);
                        vac.setCodigoUsuarioApl(apl);
                        VacinacaoJpaController daoVac = new VacinacaoJpaController(Banco.conexao);
                        daoVac.create(vac);
                        %>pronto!<%
                        Banco.conexao.close();
                    }
                }
            }
            catch(Exception ex)
            {
                Banco.conexao.close();
%>
                <h1>Erro: <%=ex.getMessage()%></h1>
<%
            }
        %>
        </div>
    </body>
</html>
