# frozen_string_literal: true

shared_examples_for 'a model with soft deletion' do
  it { is_expected.to have_db_column(:deleted_at) }

  it { is_expected.to have_db_index(:deleted_at) }

  it 'adds a deleted_at where clause' do
    expect(described_class.all.to_sql).to include('"deleted_at" IS NULL')
  end

  it 'skips adding the deleted_at where clause when unscoped' do
    expect(described_class.unscoped.to_sql).not_to include('`deleted_at`') # to_s to handle nil.
  end
end
