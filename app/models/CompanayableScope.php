<?php

use \Illuminate\Database\Eloquent\Builder;
use \Illuminate\Database\Eloquent\ScopeInterface;

final class CompanayableScope implements ScopeInterface
{
    /**
     * Apply the scope to a given Eloquent query builder.
     *
     * @param  \Illuminate\Database\Eloquent\Builder  $builder
     * @return void
     */
    public function apply(Builder $builder)
    {
        return Company::scopeCompanayables($builder);
    }

    /**
     * @todo IMPLEMENT
     * Remove the scope from the given Eloquent query builder.
     *
     * @param  \Illuminate\Database\Eloquent\Builder  $builder
     * @return void
     */
    public function remove(Builder $builder)
    {
    }
}
