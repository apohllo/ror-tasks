class CurrencyExchanger
  attr_writer :calculator

  def initialize(source_account,target_account,rate)
    @source_account = source_account
    @target_account = target_account
    @rate = rate
  end

  def exchange(limit=nil)
    source_amount = compute_source_amount(limit)
    source_amount = @source_account.balance if source_amount > @source_account.balance
    target_amount = calculator.compute_target_amount(source_amount,@rate)
    @source_account.withdraw(source_amount)
    @target_account.deposit(target_amount)
  end

  private
  def compute_source_amount(limit)
    return @source_account.balance if limit.nil?
    if limit[:target]
      calculator.compute_source_amount(limit[:target],@rate)
    else
      limit[:source]
    end
  end

  def calculator
    @calculator
  end
end
