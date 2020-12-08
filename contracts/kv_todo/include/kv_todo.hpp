#include <eosio/eosio.hpp>
#include <eosio/system.hpp>
using namespace eosio;

struct todo_entry {
  std::string uuid;
  eosio::name account_name;
  std::string task;
  bool checked;
  uint32_t created;

  std::string get_uuid() const { return uuid; }
  eosio::name get_account_name() const { return account_name; }
  std::string get_task() const { return task; }
  bool get_checked() const { return checked; }
  uint32_t get_created() const { return created; }
};

class [[eosio::contract]] kv_todo : public contract {
  public:
      using contract::contract;
      using todo_table = eosio::kv::map<"todo"_n, std::string, todo_entry>;

      [[eosio::action]]
      std::vector<todo_entry> getbyaccname(name account_name);

      [[eosio::action]]
      todo_entry upsert(const std::string& uuid,
                        eosio::name account_name,
                        const std::string& task,
                        bool checked);

      [[eosio::action]]
      void del(const std::string& uuid);

      using get_by_account_name_action = action_wrapper<"getbyaccname"_n, &kv_todo::getbyaccname>;
      using upsert_action = action_wrapper<"upsert"_n, &kv_todo::upsert>;
      using del_action = action_wrapper<"del"_n, &kv_todo::del>;

  private:
    todo_table todo_entries{"todo"_n};
};
