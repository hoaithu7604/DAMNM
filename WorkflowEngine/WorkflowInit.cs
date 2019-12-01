using System;
using System.Xml.Linq;
using OptimaJet.Workflow.Core.Builder;
using OptimaJet.Workflow.Core.Bus;
using OptimaJet.Workflow.Core.Persistence;
using OptimaJet.Workflow.Core.Runtime;
using OptimaJet.Workflow.DbPersistence;
namespace WorkflowEngine
{
    public static class WorkflowInit
    {
        private static readonly Lazy<WorkflowRuntime> LazyRuntime = new Lazy<WorkflowRuntime>(InitWorkflowRuntime);

        public static WorkflowRuntime Runtime
        {
            get { return LazyRuntime.Value; }
        }

        private static WorkflowRuntime InitWorkflowRuntime()
        {
            var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["ConnectionString"].ConnectionString;
            var dbProvider = new MSSQLProvider(connectionString);

            var builder = new WorkflowBuilder<XElement>(
                dbProvider,
                new OptimaJet.Workflow.Core.Parser.XmlWorkflowParser(),
                dbProvider
            ).WithDefaultCache();

            var runtime = new WorkflowRuntime()
                .WithBuilder(builder)
                .WithPersistenceProvider(dbProvider)
                .WithBus(new NullBus())
                .EnableCodeActions()
                .SwitchAutoUpdateSchemeBeforeGetAvailableCommandsOn();
            runtime.ProcessActivityChanged += (sender, args) => { };
            runtime.ProcessStatusChanged += (sender, args) => { };
            runtime.Start();

            runtime.ProcessStatusChanged += _runtime_ProcessStatusChanged;

            return runtime;
        }

        static void _runtime_ProcessStatusChanged(object sender, ProcessStatusChangedEventArgs e)
        {
            if (e.NewStatus != ProcessStatus.Idled && e.NewStatus != ProcessStatus.Finalized)
                return;

            if (string.IsNullOrEmpty(e.SchemeCode))
                return;

            
            Runtime.PreExecuteFromCurrentActivity(e.ProcessId);

            //Change state name
            if (!e.IsSubprocess)
            {
                var nextState = e.ProcessInstance.CurrentState;
                if (nextState == null)
                {
                    nextState = e.ProcessInstance.CurrentActivityName;
                }
                var nextStateName = Runtime.GetLocalizedStateName(e.ProcessId, nextState);
               
                var orderRepository = new OrderRepository();
              
                orderRepository.ChangeState(e.ProcessId, nextState, nextStateName);                            
            }
        }
    }
}
