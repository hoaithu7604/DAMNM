using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AutoMapper;

namespace WorkflowEngine
{
    internal static class Mappings
    {
        public static IMapper Mapper { get { return _mapper.Value; } }

        private static Lazy<IMapper> _mapper = new Lazy<IMapper>(GetMapper);

        private static IMapper GetMapper()
        {
            var config = new MapperConfiguration(cfg => {

                cfg.CreateMap<WorkflowEngine.Model.Employee, Employee>();
                cfg.CreateMap<WorkflowEngine.Model.Account, Account>();
                cfg.CreateMap<Order, WorkflowEngine.Model.Order>();
                cfg.CreateMap<WorkflowEngine.Model.OrderHistory, OrderHistory>();

            });

            var mapper = config.CreateMapper();

            return mapper;
        }
    }
}
